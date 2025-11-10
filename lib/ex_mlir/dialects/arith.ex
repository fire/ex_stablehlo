defmodule ExMLIR.Dialects.Arith do
  @moduledoc """
  Translator for MLIR arith dialect operations.

  Supports arithmetic operations like add, sub, mul, div for both integer and float types.
  """

  alias ExMLIR.ASTBuilder

  @doc """
  Translates an arith operation to Nx or Elixir code.
  """
  def translate(op, result, operands, type, state, mode) do
    {resolved_ops, new_state} = resolve_operands(operands, state, mode)

    case op do
      :addi -> translate_add(resolved_ops, result, type, new_state, mode, :integer)
      :addf -> translate_add(resolved_ops, result, type, new_state, mode, :float)
      :subi -> translate_sub(resolved_ops, result, type, new_state, mode, :integer)
      :subf -> translate_sub(resolved_ops, result, type, new_state, mode, :float)
      :muli -> translate_mul(resolved_ops, result, type, new_state, mode, :integer)
      :mulf -> translate_mul(resolved_ops, result, type, new_state, mode, :float)
      :divi -> translate_div(resolved_ops, result, type, new_state, mode, :integer)
      :divf -> translate_div(resolved_ops, result, type, new_state, mode, :float)
      :cmpi -> translate_cmp(resolved_ops, result, type, new_state, mode)
      :cmpf -> translate_cmp(resolved_ops, result, type, new_state, mode)
      :andi -> translate_bitwise(resolved_ops, result, type, new_state, mode, :band)
      :ori -> translate_bitwise(resolved_ops, result, type, new_state, mode, :bor)
      :xori -> translate_bitwise(resolved_ops, result, type, new_state, mode, :bxor)
      :shli -> translate_shift(resolved_ops, result, type, new_state, mode, :left)
      :shri -> translate_shift(resolved_ops, result, type, new_state, mode, :right)
      _ -> {nil, new_state}  # TODO: Implement remaining arith operations
    end
  end

  defp translate_add([a, b], result, _type, state, :nx, _num_type) do
    expr = ASTBuilder.nx_call(:add, [a, b])
    var_name = String.to_atom("var_#{result}")
    new_vars = Map.put(state.variables, var_name, expr)
    {expr, %{state | variables: new_vars}}
  end

  defp translate_add([a, b], result, _type, state, :elixir, _num_type) do
    expr = ASTBuilder.nx_call(:add, [a, b])
    var_name = String.to_atom("var_#{result}")
    assign_ast = ASTBuilder.assign(var_name, expr)
    new_vars = Map.put(state.variables, var_name, expr)
    new_ast = [assign_ast | (state.ast || [])]
    {expr, %{state | variables: new_vars, ast: new_ast}}
  end

  defp translate_sub([a, b], result, _type, state, :nx, _num_type) do
    expr = ASTBuilder.nx_call(:subtract, [a, b])
    var_name = String.to_atom("var_#{result}")
    new_vars = Map.put(state.variables, var_name, expr)
    {expr, %{state | variables: new_vars}}
  end

  defp translate_sub([a, b], result, _type, state, :elixir, _num_type) do
    expr = ASTBuilder.nx_call(:subtract, [a, b])
    var_name = String.to_atom("var_#{result}")
    assign_ast = ASTBuilder.assign(var_name, expr)
    new_vars = Map.put(state.variables, var_name, expr)
    new_ast = [assign_ast | (state.ast || [])]
    {expr, %{state | variables: new_vars, ast: new_ast}}
  end

  defp translate_mul([a, b], result, _type, state, :nx, _num_type) do
    expr = ASTBuilder.nx_call(:multiply, [a, b])
    var_name = String.to_atom("var_#{result}")
    new_vars = Map.put(state.variables, var_name, expr)
    {expr, %{state | variables: new_vars}}
  end

  defp translate_mul([a, b], result, _type, state, :elixir, _num_type) do
    expr = ASTBuilder.nx_call(:multiply, [a, b])
    var_name = String.to_atom("var_#{result}")
    assign_ast = ASTBuilder.assign(var_name, expr)
    new_vars = Map.put(state.variables, var_name, expr)
    new_ast = [assign_ast | (state.ast || [])]
    {expr, %{state | variables: new_vars, ast: new_ast}}
  end

  defp translate_div([a, b], result, _type, state, :nx, _num_type) do
    expr = ASTBuilder.nx_call(:divide, [a, b])
    var_name = String.to_atom("var_#{result}")
    new_vars = Map.put(state.variables, var_name, expr)
    {expr, %{state | variables: new_vars}}
  end

  defp translate_div([a, b], result, _type, state, :elixir, _num_type) do
    expr = ASTBuilder.nx_call(:divide, [a, b])
    var_name = String.to_atom("var_#{result}")
    assign_ast = ASTBuilder.assign(var_name, expr)
    new_vars = Map.put(state.variables, var_name, expr)
    new_ast = [assign_ast | (state.ast || [])]
    {expr, %{state | variables: new_vars, ast: new_ast}}
  end

  defp translate_cmp([a, b], result, _type, state, mode) do
    # TODO: Comparison operations - simplified, would need predicate parsing
    expr = ASTBuilder.nx_call(:greater, [a, b])
    var_name = String.to_atom("var_#{result}")
    
    case mode do
      :nx ->
        new_vars = Map.put(state.variables, var_name, expr)
        {expr, %{state | variables: new_vars}}

      :elixir ->
        assign_ast = ASTBuilder.assign(var_name, expr)
        new_vars = Map.put(state.variables, var_name, expr)
        new_ast = [assign_ast | (state.ast || [])]
        {expr, %{state | variables: new_vars, ast: new_ast}}
    end
  end

  defp translate_bitwise([a, b], result, _type, state, mode, op) do
    nx_op = case op do
      :band -> :bitwise_and
      :bor -> :bitwise_or
      :bxor -> :bitwise_xor
    end

    expr = ASTBuilder.nx_call(nx_op, [a, b])
    var_name = String.to_atom("var_#{result}")

    case mode do
      :nx ->
        new_vars = Map.put(state.variables, var_name, expr)
        {expr, %{state | variables: new_vars}}

      :elixir ->
        assign_ast = ASTBuilder.assign(var_name, expr)
        new_vars = Map.put(state.variables, var_name, expr)
        new_ast = [assign_ast | (state.ast || [])]
        {expr, %{state | variables: new_vars, ast: new_ast}}
    end
  end

  defp translate_shift([a, b], result, _type, state, mode, direction) do
    nx_op = case direction do
      :left -> :left_shift
      :right -> :right_shift
    end

    expr = ASTBuilder.nx_call(nx_op, [a, b])
    var_name = String.to_atom("var_#{result}")

    case mode do
      :nx ->
        new_vars = Map.put(state.variables, var_name, expr)
        {expr, %{state | variables: new_vars}}

      :elixir ->
        assign_ast = ASTBuilder.assign(var_name, expr)
        new_vars = Map.put(state.variables, var_name, expr)
        new_ast = [assign_ast | (state.ast || [])]
        {expr, %{state | variables: new_vars, ast: new_ast}}
    end
  end

  defp resolve_operands(operands, state, mode) do
    {resolved, new_state} =
      Enum.reduce(operands, {[], state}, fn op, {acc, st} ->
        {resolved_op, updated_st} = resolve_operand(op, st, mode)
        {[resolved_op | acc], updated_st}
      end)

    {Enum.reverse(resolved), new_state}
  end

  defp resolve_operand(op_str, state, mode) when is_binary(op_str) do
    cond do
      # Variable reference
      String.match?(op_str, ~r/^%\d+$/) ->
        var_name = String.to_atom("var_#{String.slice(op_str, 1..-1)}")
        case Map.get(state.variables, var_name) do
          nil -> {op_str, state}
          val -> {val, state}
        end

      # Argument reference
      String.match?(op_str, ~r/^%arg\d+$/) ->
        arg_idx = String.slice(op_str, 4..-1) |> String.to_integer()
        inputs_var = ASTBuilder.var(:inputs)
        idx_lit = ASTBuilder.literal(arg_idx)
        {ASTBuilder.enum_at(inputs_var, idx_lit), state}

      # Literal
      true ->
        literal = parse_literal(op_str)
        {literal, state}
    end
  end

  defp parse_literal(str) do
    cond do
      Regex.match?(~r/^-?\d+$/, str) ->
        ASTBuilder.literal(String.to_integer(str))

      Regex.match?(~r/^-?\d+\.\d+$/, str) ->
        ASTBuilder.literal(String.to_float(str))

      true ->
        ASTBuilder.literal(str)
    end
  end
end

