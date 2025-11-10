defmodule ExMLIR do
  @moduledoc """
  ExMLIR - Convert MLIR to Axon and Elixir to MLIR

  This library provides functionality to:
  - Parse MLIR code (StableHLO) and convert it to Axon models
  - Parse Elixir code and convert it to MLIR (StableHLO)

  ## Supported Dialects

  Only StableHLO is directly supported. All other MLIR dialects are emulated via StableHLO.

  ## Examples

  ### MLIR to Axon

      iex> mlir_code = \"""
      ...> stablehlo.add %arg0, %arg1 : tensor<f32>
      ...> \"""
      iex> ExMLIR.to_axon(mlir_code)
      # Returns Axon model

  ### Elixir to MLIR

      iex> elixir_code = \"""
      ...> defn add(a, b) do
      ...>   Nx.add(a, b)
      ...> end
      ...> \"""
      iex> ExMLIR.from_elixir(elixir_code)
      # Returns MLIR (StableHLO) code string

      iex> ExMLIR.from_axon(axon_model)
      # Returns MLIR code from Axon model
  """

  alias ExMLIR.Parser
  alias ExMLIR.Translator
  alias ExMLIR.ElixirParser
  alias ExMLIR.AxonToMLIR

  @doc """
  Converts MLIR code to Axon model.

  Returns an Axon model that can be used for training or inference.
  """
  def to_axon(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> Parser.parse()
    |> Translator.to_axon()
  end

  @doc """
  Converts Elixir code to MLIR code string.

  Parses Elixir code (typically Axon/Nx operations) and converts to MLIR (StableHLO).
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
  Converts an Axon model to MLIR code string.

  Takes an Axon model and converts it to MLIR (StableHLO) representation.
  """
  def from_axon(model) do
    AxonToMLIR.convert(model)
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

