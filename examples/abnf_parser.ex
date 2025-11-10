defmodule ExMLIR.Examples.ABNFParser do
  @moduledoc """
  Examples of using the ABNF-based StableHLO parser.

  Demonstrates parsing StableHLO MLIR code using the ABNF grammar parser.
  """

  alias ExMLIR.Parser
  alias ExMLIR.Parser.StableHLOABNF

  @doc """
  Example: Parse a simple StableHLO function using ABNF parser.
  """
  def example_simple_function do
    mlir_code = """
    func.func @add(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
      %0 = "stablehlo.add"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
      func.return %0 : tensor<f32>
    }
    """

    case StableHLOABNF.parse_text(mlir_code) do
      {:ok, ast} ->
        IO.puts("Successfully parsed:")
        IO.inspect(ast, pretty: true)
        {mlir_code, ast}

      {:error, reason} ->
        IO.puts("Parse error: #{inspect(reason)}")
        {mlir_code, {:error, reason}}
    end
  end

  @doc """
  Example: Parse a more complex StableHLO function.
  """
  def example_complex_function do
    mlir_code = """
    func.func @main(
      %image: tensor<28x28xf32>,
      %weights: tensor<784x10xf32>,
      %bias: tensor<1x10xf32>
    ) -> tensor<1x10xf32> {
      %0 = "stablehlo.reshape"(%image) : (tensor<28x28xf32>) -> tensor<1x784xf32>
      %1 = "stablehlo.dot_general"(%0, %weights) : (tensor<1x784xf32>, tensor<784x10xf32>) -> tensor<1x10xf32>
      %2 = "stablehlo.add"(%1, %bias) : (tensor<1x10xf32>, tensor<1x10xf32>) -> tensor<1x10xf32>
      func.return %2 : tensor<1x10xf32>
    }
    """

    case StableHLOABNF.parse_text(mlir_code) do
      {:ok, ast} ->
        IO.puts("Successfully parsed complex function:")
        IO.inspect(ast, pretty: true)
        {mlir_code, ast}

      {:error, reason} ->
        IO.puts("Parse error: #{inspect(reason)}")
        {mlir_code, {:error, reason}}
    end
  end

  @doc """
  Example: Parse with constant values.
  """
  def example_with_constants do
    mlir_code = """
    func.func @test(%arg0: tensor<f32>) -> tensor<f32> {
      %0 = "stablehlo.constant"() {value = dense<1.0> : tensor<f32>} : () -> tensor<f32>
      %1 = "stablehlo.add"(%arg0, %0) : (tensor<f32>, tensor<f32>) -> tensor<f32>
      func.return %1 : tensor<f32>
    }
    """

    case StableHLOABNF.parse_text(mlir_code) do
      {:ok, ast} ->
        IO.puts("Successfully parsed with constants:")
        IO.inspect(ast, pretty: true)
        {mlir_code, ast}

      {:error, reason} ->
        IO.puts("Parse error: #{inspect(reason)}")
        {mlir_code, {:error, reason}}
    end
  end

  @doc """
  Example: Load and inspect the ABNF grammar.
  """
  def example_load_grammar do
    case StableHLOABNF.load_grammar() do
      {:ok, grammar} ->
        IO.puts("Grammar loaded successfully")
        IO.puts("Grammar structure:")
        IO.inspect(grammar, pretty: true, limit: :infinity)
        {:ok, grammar}

      {:error, reason} ->
        IO.puts("Failed to load grammar: #{inspect(reason)}")
        {:error, reason}
    end
  end
end

