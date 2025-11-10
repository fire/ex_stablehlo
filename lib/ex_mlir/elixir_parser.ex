defmodule ExMLIR.ElixirParser do
  @moduledoc """
  Parser for Elixir code (Nx/Axon) to convert to MLIR.

  Uses Sourceror to parse Elixir source code and extract Nx/Axon operations.
  """

  @doc """
  Parses Elixir code string and extracts Nx/Axon operations.
  """
  def parse(elixir_code) when is_binary(elixir_code) do
    case Sourceror.parse_string(elixir_code) do
      {:ok, ast} ->
        extract_operations(ast)

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Parses an Elixir AST and extracts operations.
  """
  def parse_ast(ast) do
    extract_operations(ast)
  end

  defp extract_operations(ast) do
    case ast do
      # Function definition
      {:def, _, [{name, _, args}, [do: body]]} ->
        {:function, name, args, extract_operations(body)}

      # Nx function calls
      {{:., _, [{:__aliases__, _, [:Nx]}, op]}, _, args} ->
        {:nx_op, op, args}

      # Axon function calls
      {{:., _, [{:__aliases__, _, [:Axon]}, op]}, _, args} ->
        {:axon_op, op, args}

      # Variable assignment
      {:=, _, [var, value]} ->
        {:assign, var, extract_operations(value)}

      # Block of statements
      {:__block__, _, statements} ->
        Enum.map(statements, &extract_operations/1)

      # Variable reference
      {var, _, nil} when is_atom(var) ->
        {:var, var}

      # Literal values
      value when is_integer(value) or is_float(value) ->
        {:literal, value}

      # List
      list when is_list(list) ->
        Enum.map(list, &extract_operations/1)

      # Tuple
      tuple when is_tuple(tuple) ->
        tuple
        |> Tuple.to_list()
        |> Enum.map(&extract_operations/1)
        |> List.to_tuple()

      # Other expressions
      other ->
        # TODO: Handle unknown expression types
        {:unknown, other}
    end
  end
end

