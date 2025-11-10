defmodule ExMLIR.Parser do
  @moduledoc """
  Parser for MLIR text format.

  Parses MLIR code into an abstract syntax tree (AST) representation.
  """

  @doc """
  Parses MLIR code string into an AST.
  """
  def parse(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == "" or String.starts_with?(&1, "//")))
    |> parse_lines()
  end

  defp parse_lines(lines) do
    {operations, _} =
      Enum.reduce(lines, {[], nil}, fn line, {acc, current_func} ->
        cond do
          # Function definition
          String.match?(line, ~r/^func\.func/) ->
            func_name = extract_func_name(line)
            func_sig = extract_func_signature(line)
            {[{:func_def, func_name, func_sig, []} | acc], func_name}

          # Function end
          String.match?(line, ~r/^}$/) ->
            {acc, nil}

          # Operation
          String.match?(line, ~r/^\s+%/) ->
            op = parse_operation(line)
            if current_func do
              {update_func_ops(acc, current_func, op), current_func}
            else
              {[op | acc], current_func}
            end

          # Return statement
          String.match?(line, ~r/^\s+return/) ->
            return_op = parse_return(line)
            if current_func do
              {update_func_ops(acc, current_func, return_op), current_func}
            else
              {[return_op | acc], current_func}
            end

          true ->
            {acc, current_func}
        end
      end)

    Enum.reverse(operations)
  end

  defp extract_func_name(line) do
    case Regex.run(~r/@(\w+)/, line) do
      [_, name] -> String.to_atom(name)
      _ -> :main
    end
  end

  defp extract_func_signature(line) do
    # Extract arguments and return type
    args = extract_args(line)
    return_type = extract_return_type(line)
    {args, return_type}
  end

  defp extract_args(line) do
    case Regex.scan(~r/%arg\d+:\s*(\w+)/, line) do
      matches ->
        Enum.map(matches, fn [_, type] ->
          {:arg, parse_type(type)}
        end)
      _ -> []
    end
  end

  defp extract_return_type(line) do
    case Regex.run(~r/->\s*(\w+)/, line) do
      [_, type] -> parse_type(type)
      _ -> nil
    end
  end

  defp parse_operation(line) do
    cond do
      # Arithmetic operations
      String.match?(line, ~r/arith\.(addi|addf|subi|subf|muli|mulf|divi|divf)/) ->
        parse_arith_op(line)

      # Memory operations
      String.match?(line, ~r/memref\./) ->
        parse_memref_op(line)

      # Control flow
      String.match?(line, ~r/scf\./) ->
        parse_scf_op(line)

      # Assignment
      String.match?(line, ~r/^%\d+\s*=\s*/) ->
        parse_assignment(line)

      true ->
        {:unknown, line}
    end
  end

  defp parse_arith_op(line) do
    case Regex.run(~r/%(\d+)\s*=\s*arith\.(\w+)\s+(.+?)\s*:\s*(\w+)/, line) do
      [_, result, op, operands, type] ->
        ops = String.split(operands, ",") |> Enum.map(&String.trim/1)
        {:arith, String.to_atom(op), result, ops, parse_type(type)}

      _ ->
        {:unknown, line}
    end
  end

  defp parse_memref_op(line) do
    case Regex.run(~r/%(\d+)\s*=\s*memref\.(\w+)\s+(.+)/, line) do
      [_, result, op, rest] ->
        {:memref, String.to_atom(op), result, parse_memref_args(rest)}

      _ ->
        {:unknown, line}
    end
  end

  defp parse_memref_args(rest) do
    # Simplified parsing - can be enhanced
    String.split(rest, ",") |> Enum.map(&String.trim/1)
  end

  defp parse_scf_op(line) do
    case Regex.run(~r/scf\.(\w+)/, line) do
      [_, op] ->
        {:scf, String.to_atom(op), line}

      _ ->
        {:unknown, line}
    end
  end

  defp parse_assignment(line) do
    case Regex.run(~r/%(\d+)\s*=\s*(.+)/, line) do
      [_, result, expr] ->
        {:assign, result, String.trim(expr)}

      _ ->
        {:unknown, line}
    end
  end

  defp parse_return(line) do
    case Regex.run(~r/return\s+(.+?)\s*:\s*(\w+)/, line) do
      [_, value, type] ->
        {:return, String.trim(value), parse_type(type)}

      _ ->
        {:return, nil, nil}
    end
  end

  defp parse_type(type_str) do
    cond do
      String.starts_with?(type_str, "i") ->
        size = String.slice(type_str, 1..-1) |> String.to_integer()
        {:integer, size}

      String.starts_with?(type_str, "f") ->
        size = String.slice(type_str, 1..-1) |> String.to_integer()
        {:float, size}

      String.starts_with?(type_str, "memref") ->
        parse_memref_type(type_str)

      true ->
        {:unknown, type_str}
    end
  end

  defp parse_memref_type(type_str) do
    # Simplified - parse memref<shape, type>
    case Regex.run(~r/memref<(.+?)>/, type_str) do
      [_, inner] ->
        parts = String.split(inner, ",") |> Enum.map(&String.trim/1)
        {:memref, parts}

      _ ->
        {:memref, []}
    end
  end

  defp update_func_ops(acc, func_name, op) do
    Enum.map(acc, fn
      {:func_def, ^func_name, sig, ops} ->
        {:func_def, func_name, sig, [op | ops]}

      other ->
        other
    end)
  end
end

