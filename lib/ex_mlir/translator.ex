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
  Translates MLIR AST to Nx computation graph.
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
  Translates MLIR AST to Axon model.
  """
  def to_axon(ast) do
    # For now, convert to Nx and wrap in Axon
    nx_expr = to_nx(ast)
    # This is a simplified approach - in practice, you'd want more sophisticated
    # conversion to Axon layers
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

        {:arith, op, result, operands, type} ->
          Arith.translate(op, result, operands, type, st, mode)

        {:scf, op, line} ->
          SCF.translate(op, line, st, mode)

        {:memref, op, result, args} ->
          Memref.translate(op, result, args, st, mode)

        {:return, value, type} ->
          {value_expr, new_st} = resolve_value(value, st, mode)
          {value_expr, new_st}

        {:assign, result, expr} ->
          {expr_val, new_st} = resolve_value(expr, st, mode)
          var_name = String.to_atom("var_#{result}")
          new_vars = Map.put(new_st.variables, var_name, expr_val)
          
          # For elixir mode, create assignment AST
          updated_st = case mode do
            :elixir ->
              assign_ast = ASTBuilder.assign(var_name, expr_val)
              new_ast = [assign_ast | (new_st.ast || [])]
              %{new_st | variables: new_vars, ast: new_ast}
            _ ->
              %{new_st | variables: new_vars}
          end
          
          {expr_val, updated_st}

        _ ->
          {acc, st}
      end
    end)
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

