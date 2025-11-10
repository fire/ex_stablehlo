defmodule ExMLIR.NxToMLIR do
  @moduledoc """
  Converts Nx operations to MLIR operations.
  """

  alias ExMLIR.MLIRGenerator

  @doc """
  Converts Nx operations to MLIR code.
  """
  def convert(operations) when is_list(operations) do
    operations
    |> Enum.reduce({[], 0, %{}}, fn op, {mlir_ops, var_counter, var_map} ->
      convert_operation(op, mlir_ops, var_counter, var_map)
    end)
    |> elem(0)
    |> MLIRGenerator.generate()
  end

  defp convert_operation({:nx_op, op, args}, mlir_ops, var_counter, var_map) do
    case op do
      :add -> convert_binary_op(:addi, args, mlir_ops, var_counter, var_map)
      :subtract -> convert_binary_op(:subi, args, mlir_ops, var_counter, var_map)
      :multiply -> convert_binary_op(:muli, args, mlir_ops, var_counter, var_map)
      :divide -> convert_binary_op(:divi, args, mlir_ops, var_counter, var_map)
      :greater -> convert_binary_op(:cmpi, args, mlir_ops, var_counter, var_map)
      :less -> convert_binary_op(:cmpi, args, mlir_ops, var_counter, var_map)
      :equal -> convert_binary_op(:cmpi, args, mlir_ops, var_counter, var_map)
      :bitwise_and -> convert_binary_op(:andi, args, mlir_ops, var_counter, var_map)
      :bitwise_or -> convert_binary_op(:ori, args, mlir_ops, var_counter, var_map)
      :bitwise_xor -> convert_binary_op(:xori, args, mlir_ops, var_counter, var_map)
      :left_shift -> convert_binary_op(:shli, args, mlir_ops, var_counter, var_map)
      :right_shift -> convert_binary_op(:shri, args, mlir_ops, var_counter, var_map)
      :tensor -> convert_tensor(args, mlir_ops, var_counter, var_map)
      :broadcast -> convert_broadcast(args, mlir_ops, var_counter, var_map)
      :tensor_slice -> convert_slice(args, mlir_ops, var_counter, var_map)
      :put_slice -> convert_put_slice(args, mlir_ops, var_counter, var_map)
      :axis_size -> convert_axis_size(args, mlir_ops, var_counter, var_map)
      _ -> {mlir_ops, var_counter, var_map}
    end
  end

  defp convert_operation({:assign, var, value}, mlir_ops, var_counter, var_map) do
    {new_ops, new_counter, new_map} = convert_operation(value, mlir_ops, var_counter, var_map)
    var_name = extract_var_name(var)
    updated_map = Map.put(new_map, var_name, new_counter - 1)
    {new_ops, new_counter, updated_map}
  end

  defp convert_operation({:var, var}, mlir_ops, var_counter, var_map) do
    case Map.get(var_map, var) do
      nil -> {mlir_ops, var_counter, var_map}
      idx -> {[{:var_ref, idx} | mlir_ops], var_counter, var_map}
    end
  end

  defp convert_operation({:literal, value}, mlir_ops, var_counter, var_map) do
    {[{:literal, value} | mlir_ops], var_counter, var_map}
  end

  defp convert_operation(other, mlir_ops, var_counter, var_map) do
    {[{:unknown, other} | mlir_ops], var_counter, var_map}
  end

  defp convert_binary_op(mlir_op, [a, b], mlir_ops, var_counter, var_map) do
    {a_ops, a_counter, a_map} = convert_operand(a, mlir_ops, var_counter, var_map)
    {b_ops, b_counter, b_map} = convert_operand(b, a_ops, a_counter, a_map)
    
    result_var = b_counter
    a_ref = resolve_operand_ref(a, a_map, a_counter - 1)
    b_ref = resolve_operand_ref(b, b_map, b_counter - 1)
    
    mlir_op_node = {:arith, mlir_op, result_var, [a_ref, b_ref], {:integer, 32}}
    {[mlir_op_node | b_ops], b_counter + 1, b_map}
  end

  defp convert_operand({:var, var}, mlir_ops, var_counter, var_map) do
    {mlir_ops, var_counter, var_map}
  end

  defp convert_operand({:literal, _value}, mlir_ops, var_counter, var_map) do
    {mlir_ops, var_counter, var_map}
  end

  defp convert_operand(other, mlir_ops, var_counter, var_map) do
    convert_operation(other, mlir_ops, var_counter, var_map)
  end

  defp resolve_operand_ref({:var, var}, var_map, default) do
    Map.get(var_map, var, default)
    |> case do
      idx when is_integer(idx) -> "%#{idx}"
      _ -> "%arg0"
    end
  end

  defp resolve_operand_ref({:literal, value}, _var_map, _default) do
    "#{value}"
  end

  defp resolve_operand_ref(_, _var_map, default) do
    "%#{default}"
  end

  defp convert_tensor([value], mlir_ops, var_counter, var_map) do
    # Convert to memref.alloc or constant
    mlir_op = {:memref, :alloc, var_counter, []}
    {[mlir_op | mlir_ops], var_counter + 1, var_map}
  end

  defp convert_broadcast([tensor, shape], mlir_ops, var_counter, var_map) do
    # Broadcast is typically handled by memref operations
    {mlir_ops, var_counter, var_map}
  end

  defp convert_slice([tensor, indices], mlir_ops, var_counter, var_map) do
    mlir_op = {:memref, :load, var_counter, [tensor, indices]}
    {[mlir_op | mlir_ops], var_counter + 1, var_map}
  end

  defp convert_put_slice([tensor, indices, value], mlir_ops, var_counter, var_map) do
    mlir_op = {:memref, :store, var_counter, [value, tensor, indices]}
    {[mlir_op | mlir_ops], var_counter + 1, var_map}
  end

  defp convert_axis_size([tensor, dim], mlir_ops, var_counter, var_map) do
    mlir_op = {:memref, :dim, var_counter, [tensor, dim]}
    {[mlir_op | mlir_ops], var_counter + 1, var_map}
  end

  defp extract_var_name({var, _, nil}) when is_atom(var), do: var
  defp extract_var_name(var) when is_atom(var), do: var
  defp extract_var_name(_), do: :unknown
end

