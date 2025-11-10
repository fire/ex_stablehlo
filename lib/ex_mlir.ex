defmodule ExMLIR do
  @moduledoc """
  ExMLIR - Bidirectional conversion between MLIR and Elixir Nx/Axon

  This library provides functionality to:
  - Parse MLIR code and convert it to Elixir code using Nx (numerical computing) and Axon (neural networks)
  - Parse Elixir/Nx/Axon code and convert it back to MLIR

  ## Supported Dialects

  - `arith`: Arithmetic operations (add, sub, mul, div, etc.)
  - `scf`: Structured control flow (loops, conditionals)
  - `memref`: Memory references and operations
  - `func`: Function definitions and calls

  ## Examples

  ### MLIR to Elixir

      iex> mlir_code = \"""
      ...> func.func @main(%arg0: i32, %arg1: i32) -> i32 {
      ...>   %0 = arith.addi %arg0, %arg1 : i32
      ...>   return %0 : i32
      ...> }
      ...> \"""
      iex> ExMLIR.to_nx(mlir_code)
      # Returns Nx computation graph
      iex> ExMLIR.to_elixir(mlir_code)
      # Returns Elixir code string

  ### Elixir to MLIR

      iex> elixir_code = \"""
      ...> defn add(a, b) do
      ...>   Nx.add(a, b)
      ...> end
      ...> \"""
      iex> ExMLIR.from_elixir(elixir_code)
      # Returns MLIR code string

      iex> ExMLIR.from_nx(nx_operations)
      # Returns MLIR code from Nx operations

      iex> ExMLIR.from_axon(axon_model)
      # Returns MLIR code from Axon model
  """

  alias ExMLIR.Parser
  alias ExMLIR.Translator
  alias ExMLIR.ElixirParser
  alias ExMLIR.NxToMLIR
  alias ExMLIR.AxonToMLIR

  @doc """
  Converts MLIR code to Nx computation graph.

  Returns a function that takes input tensors and returns output tensors.
  """
  def to_nx(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> Parser.parse()
    |> Translator.to_nx()
  end

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
  Converts MLIR code to Elixir code string.

  Returns a string containing Elixir code that can be evaluated.
  """
  def to_elixir(mlir_code) when is_binary(mlir_code) do
    mlir_code
    |> Parser.parse()
    |> Translator.to_elixir()
  end

  @doc """
  Converts Elixir code to MLIR code string.

  Parses Elixir code (typically Nx/Axon operations) and converts to MLIR.
  """
  def from_elixir(elixir_code) when is_binary(elixir_code) do
    case ElixirParser.parse(elixir_code) do
      {:ok, operations} ->
        NxToMLIR.convert(operations)

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Converts Nx operations to MLIR code string.

  Takes a list of Nx operations and converts them to MLIR.
  """
  def from_nx(operations) when is_list(operations) do
    NxToMLIR.convert(operations)
  end

  @doc """
  Converts an Axon model to MLIR code string.

  Takes an Axon model and converts it to MLIR representation.
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
    NxToMLIR.convert(operations)
  end
end

