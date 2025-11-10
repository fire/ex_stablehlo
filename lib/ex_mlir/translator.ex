defmodule ExMLIR.Translator do
  @moduledoc """
  Translates MLIR AST to Nx, Axon, or Elixir code.
  """

  alias ExMLIR.Dialects.Arith
  alias ExMLIR.Dialects.SCF
  alias ExMLIR.Dialects.Memref
  alias ExMLIR.Dialects.Func
  alias ExMLIR.ASTBuilder

  @doc """
  Translates MLIR AST to Nx computation function.

  Converts StableHLO operations to Nx operations.
  """
  def to_nx(ast) do
    state = %{
      variables: %{},
      inputs: [],
      outputs: []
    }

    {nx_expr, _state} = translate_ast(ast, state, :nx)
    nx_expr
  end

  @doc """
  Translates MLIR AST to Elixir code string.
  """
  def to_elixir(ast) do
    {ast_nodes, state} = translate_ast(ast, %{variables: %{}, ast: []}, :elixir)
    
    # Combine all AST nodes into a block and convert to string
    combined_ast = case ast_nodes do
      nodes when is_list(nodes) -> ASTBuilder.block(nodes)
      node -> node
    end
    
    ASTBuilder.to_string(combined_ast)
  end

  defp translate_ast(ast, state, mode) do
    Enum.reduce(ast, {nil, state}, fn node, {acc, st} ->
      case node do
        {:func_def, name, {args, return_type}, ops} ->
          Func.translate(name, args, return_type, ops, st, mode)

        {:stablehlo, op, result, operands, type} ->
          translate_stablehlo(op, result, operands, type, st, mode)

        {:arith, op, result, operands, type} ->
          # Emulate arith via StableHLO
          stablehlo_op = map_arith_to_stablehlo(op)
          translate_stablehlo(stablehlo_op, result, operands, type, st, mode)

        {:scf, op, line} ->
          # Emulate scf via StableHLO
          translate_scf_via_stablehlo(op, line, st, mode)

        {:memref, op, result, args} ->
          # Emulate memref via StableHLO
          translate_memref_via_stablehlo(op, result, args, st, mode)

        {:return, value, type} ->
          {value_expr, new_st} = resolve_value(value, st, mode)
          {value_expr, new_st}

        {:assign, result, expr} ->
          {expr_val, new_st} = resolve_value(expr, st, mode)
          var_name = String.to_atom("var_#{result}")
          new_vars = Map.put(new_st.variables, var_name, expr_val)
          %{new_st | variables: new_vars}

        _ ->
          {acc, st}
      end
    end)
  end

  defp translate_stablehlo(op, result, operands, type, state, mode) do
    case mode do
      :nx ->
        # Convert StableHLO operation to Nx operation
        nx_op = case op do
          :add -> build_nx_add(operands, state)
          :multiply -> build_nx_multiply(operands, state)
          :subtract -> build_nx_subtract(operands, state)
          :divide -> build_nx_divide(operands, state)
          :dot_general -> build_nx_dot(operands, state)
          :convolution -> build_nx_conv(operands, state)
          _ -> nil
        end
        
        if nx_op do
          var_name = String.to_atom("var_#{result}")
          new_vars = Map.put(state.variables, var_name, nx_op)
          {nx_op, %{state | variables: new_vars}}
        else
          {nil, state}
        end
    end
  end

  defp build_nx_add([a, b], state) do
    a_expr = resolve_operand(a, state)
    b_expr = resolve_operand(b, state)
    ASTBuilder.nx_call(:add, [a_expr, b_expr])
  end

  defp build_nx_multiply([a, b], state) do
    a_expr = resolve_operand(a, state)
    b_expr = resolve_operand(b, state)
    ASTBuilder.nx_call(:multiply, [a_expr, b_expr])
  end

  defp build_nx_subtract([a, b], state) do
    a_expr = resolve_operand(a, state)
    b_expr = resolve_operand(b, state)
    ASTBuilder.nx_call(:subtract, [a_expr, b_expr])
  end

  defp build_nx_divide([a, b], state) do
    a_expr = resolve_operand(a, state)
    b_expr = resolve_operand(b, state)
    ASTBuilder.nx_call(:divide, [a_expr, b_expr])
  end

  defp build_nx_dot([a, b], state) do
    a_expr = resolve_operand(a, state)
    b_expr = resolve_operand(b, state)
    ASTBuilder.nx_call(:dot, [a_expr, b_expr])
  end

  defp build_nx_conv([input, filter], state) do
    input_expr = resolve_operand(input, state)
    filter_expr = resolve_operand(filter, state)
    ASTBuilder.nx_call(:conv, [input_expr, filter_expr])
  end

  defp resolve_operand(operand_str, state) when is_binary(operand_str) do
    cond do
      # Variable reference
      String.match?(operand_str, ~r/^%\d+$/) ->
        var_name = String.to_atom("var_#{String.slice(operand_str, 1..-1)}")
        case Map.get(state.variables, var_name) do
          nil -> ASTBuilder.var(var_name)
          val -> val
        end

      # Argument reference
      String.match?(operand_str, ~r/^%arg\d+$/) ->
        arg_idx = String.slice(operand_str, 4..-1) |> String.to_integer()
        inputs_var = ASTBuilder.var(:inputs)
        idx_lit = ASTBuilder.literal(arg_idx)
        ASTBuilder.enum_at(inputs_var, idx_lit)

      # Literal
      true ->
        parse_literal(operand_str)
    end
  end

  defp resolve_operand(other, _state), do: other

  defp map_arith_to_stablehlo(:addi), do: :add
  defp map_arith_to_stablehlo(:addf), do: :add
  defp map_arith_to_stablehlo(:subi), do: :subtract
  defp map_arith_to_stablehlo(:subf), do: :subtract
  defp map_arith_to_stablehlo(:muli), do: :multiply
  defp map_arith_to_stablehlo(:mulf), do: :multiply
  defp map_arith_to_stablehlo(:divi), do: :divide
  defp map_arith_to_stablehlo(:divf), do: :divide
  defp map_arith_to_stablehlo(_), do: :add

  defp translate_scf_via_stablehlo(op, _line, state, mode) do
    # SCF operations emulated via StableHLO control flow
    case op do
      :if -> {nil, state}  # Would use stablehlo.if
      :while -> {nil, state}  # Would use stablehlo.while
      _ -> {nil, state}
    end
  end

  defp translate_memref_via_stablehlo(op, _result, _args, state, mode) do
    # Memref operations emulated via StableHLO tensor operations
    {nil, state}
  end

  defp resolve_value(value_str, state, mode) when is_binary(value_str) do
    cond do
      # Variable reference
      String.match?(value_str, ~r/^%\d+$/) ->
        var_name = String.to_atom("var_#{String.slice(value_str, 1..-1)}")
        case Map.get(state.variables, var_name) do
          nil -> {value_str, state}
          val -> {val, state}
        end

      # Argument reference
      String.match?(value_str, ~r/^%arg\d+$/) ->
        arg_idx = String.slice(value_str, 4..-1) |> String.to_integer()
        case mode do
          :nx -> 
            inputs_var = ASTBuilder.var(:inputs)
            idx_lit = ASTBuilder.literal(arg_idx)
            {ASTBuilder.enum_at(inputs_var, idx_lit), state}
          :elixir -> 
            inputs_var = ASTBuilder.var(:inputs)
            idx_lit = ASTBuilder.literal(arg_idx)
            {ASTBuilder.enum_at(inputs_var, idx_lit), state}
        end

      # Literal
      true ->
        {parse_literal(value_str), state}
    end
  end

  defp parse_literal(str) do
    cond do
      Regex.match?(~r/^-?\d+$/, str) ->
        String.to_integer(str)

      Regex.match?(~r/^-?\d+\.\d+$/, str) ->
        String.to_float(str)

      true ->
        str
    end
  end
end

