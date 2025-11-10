defmodule ExMLIR.Examples.MLIRToNx do
  @moduledoc """
  Examples of converting MLIR (StableHLO) to Elixir/Nx.
  """

  alias ExMLIR

  @doc """
  Example: Convert simple StableHLO addition to Nx.
  """
  def example_simple_add do
    mlir_code = """
    func.func @add(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
      %0 = stablehlo.add %arg0, %arg1 : tensor<f32>
      func.return %0 : tensor<f32>
    }
    """

    elixir_code = ExMLIR.to_elixir(mlir_code)
    nx_func = ExMLIR.to_nx(mlir_code)
    {mlir_code, elixir_code, nx_func}
  end

  @doc """
  Example: Convert StableHLO operations to Nx computation.
  """
  def example_dense_operation do
    mlir_code = """
    func.func @dense(%input: tensor<f32>, %weights: tensor<f32>, %bias: tensor<f32>) -> tensor<f32> {
      %0 = stablehlo.dot_general %input, %weights : tensor<f32>
      %1 = stablehlo.add %0, %bias : tensor<f32>
      func.return %1 : tensor<f32>
    }
    """

    elixir_code = ExMLIR.to_elixir(mlir_code)
    nx_func = ExMLIR.to_nx(mlir_code)
    {mlir_code, elixir_code, nx_func}
  end

  @doc """
  Example: Convert StableHLO convolution to Nx.
  """
  def example_conv_operation do
    mlir_code = """
    func.func @conv(%input: tensor<f32>, %filter: tensor<f32>) -> tensor<f32> {
      %0 = stablehlo.convolution %input, %filter {
        window_strides = array<i64: 1, 1>,
        padding = array<i64: 0, 0, 0, 0>
      } : (tensor<f32>, tensor<f32>) -> tensor<f32>
      func.return %0 : tensor<f32>
    }
    """

    elixir_code = ExMLIR.to_elixir(mlir_code)
    nx_func = ExMLIR.to_nx(mlir_code)
    {mlir_code, elixir_code, nx_func}
  end
end

