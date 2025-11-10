defmodule ExMLIR.MLIRGenerator do
  @moduledoc """
  Generates MLIR code from an internal representation.
  """

  @doc """
  Generates MLIR code string from operations list.
  """
  def generate(operations) when is_list(operations) do
    operations
    |> Enum.map(&generate_operation/1)
    |> Enum.join("\n")
  end

  defp generate_operation({:func_def, name, {args, return_type}, ops}) do
    args_str = generate_args(args)
    return_str = generate_return_type(return_type)
    ops_str = Enum.map_join(ops, "\n  ", &generate_operation/1)
    
    """
    func.func @#{name}(#{args_str}) -> #{return_str} {
      #{ops_str}
    }
    """
  end

  defp generate_operation({:stablehlo, op, result, operands, type}) do
    ops_str = Enum.join(operands, ", ")
    type_str = format_type(type)
    "  %#{result} = stablehlo.#{op} #{ops_str} : #{type_str}"
  end

  defp generate_operation({:arith, op, result, operands, type}) do
    # Emulated via StableHLO
    ops_str = Enum.join(operands, ", ")
    type_str = format_type(type)
    "  %#{result} = stablehlo.#{map_arith_to_stablehlo(op)} #{ops_str} : #{type_str}"
  end

  defp map_arith_to_stablehlo(:addi), do: :add
  defp map_arith_to_stablehlo(:addf), do: :add
  defp map_arith_to_stablehlo(:subi), do: :subtract
  defp map_arith_to_stablehlo(:subf), do: :subtract
  defp map_arith_to_stablehlo(:muli), do: :multiply
  defp map_arith_to_stablehlo(:mulf), do: :multiply
  defp map_arith_to_stablehlo(:divi), do: :divide
  defp map_arith_to_stablehlo(:divf), do: :divide
  defp map_arith_to_stablehlo(_), do: :add

  defp generate_operation({:memref, op, result, args}) do
    # TODO: Implement memref operation generation
    args_str = Enum.join(args, ", ")
    "  %#{result} = memref.#{op} #{args_str}"
  end

  defp generate_operation({:scf, op, _line}) do
    # TODO: Implement scf operation generation
    "  scf.#{op} ..."
  end

  defp generate_operation({:return, value, type}) do
    type_str = format_type(type)
    "  return #{value} : #{type_str}"
  end

  defp generate_operation({:assign, result, _expr}) do
    # TODO: Implement assignment operation generation
    "# Assignment to %#{result}"
  end

  defp generate_operation(other) do
    # TODO: Handle unknown operations
    "# #{inspect(other)}"
  end

  defp generate_args(args) do
    args
    |> Enum.with_index()
    |> Enum.map_join(", ", fn {{:arg, type}, idx} ->
      type_str = format_type(type)
      "%arg#{idx}: #{type_str}"
    end)
  end

  defp generate_return_type(nil), do: ""
  defp generate_return_type(type), do: format_type(type)

  defp format_type({:integer, size}), do: "i#{size}"
  defp format_type({:float, size}), do: "f#{size}"
  defp format_type({:memref, _}), do: "memref<?x?xf32>"
  defp format_type({:unknown, str}), do: str
  defp format_type(_), do: "i32"
end

