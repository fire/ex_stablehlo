defmodule ExMLIR do
  @moduledoc """
  ExMLIR - Convert MLIR (StableHLO) to Elixir/Nx and Elixir to MLIR

  This library provides functionality to:
  - Parse MLIR code (StableHLO) and convert it to Elixir/Nx code
  - Parse Elixir code and convert it to MLIR (StableHLO)

  ## Supported Dialects

  Only StableHLO is directly supported. All other MLIR dialects are emulated via StableHLO.

  ## Examples

  ### MLIR to Elixir/Nx

      iex> mlir_code = \"""
      ...> stablehlo.add %arg0, %arg1 : tensor<f32>
      ...> \"""
      iex> ExMLIR.to_elixir(mlir_code)
      # Returns Elixir code string
      iex> ExMLIR.to_nx(mlir_code)
      # Returns Nx computation function

  ### Elixir to MLIR

      iex> elixir_code = \"""
      ...> defn add(a, b) do
      ...>   Nx.add(a, b)
      ...> end
      ...> \"""
      iex> ExMLIR.from_elixir(elixir_code)
      # Returns MLIR (StableHLO) code string
  """

  alias ExMLIR.Parser
  alias ExMLIR.Translator
  alias ExMLIR.ElixirParser
  alias ExMLIR.AxonToMLIR

  @doc """
  Converts MLIR code to Elixir code string.

  Returns a string containing Elixir code that can be evaluated.
  """
  def to_elixir(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> Parser.parse()
    |> Translator.to_elixir()
  end

  @doc """
  Converts MLIR code to Nx computation function.

  Returns a function that takes input tensors and returns output tensors.
  """
  def to_nx(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> Parser.parse()
    |> Translator.to_nx()
  end

  @doc """
  Converts Elixir code to MLIR code string.

  Parses Elixir code (typically Nx operations) and converts to MLIR (StableHLO).
  """
  def from_elixir(elixir_code) when is_binary(elixir_code) do
    case ElixirParser.parse(elixir_code) do
      {:ok, operations} ->
        AxonToMLIR.convert_from_operations(operations)

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Converts Elixir AST to MLIR code string.

  Takes an Elixir AST (from Sourceror or Code.string_to_quoted) and converts to MLIR.
  """
  def from_ast(ast) do
    operations = ElixirParser.parse_ast(ast)
    AxonToMLIR.convert_from_operations(operations)
  end
end

