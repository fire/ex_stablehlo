defmodule ExMLIR.Examples.MLIRToAxon do
  @moduledoc """
  Examples of converting MLIR (StableHLO) to Axon models.
  """

  alias ExMLIR

  @doc """
  Example: Convert simple StableHLO addition to Axon.
  """
  def example_simple_add do
    mlir_code = """
    stablehlo.add %arg0, %arg1 : tensor<f32>
    """

    axon_model = ExMLIR.to_axon(mlir_code)
    {mlir_code, axon_model}
  end

  @doc """
  Example: Convert StableHLO operations to Axon dense layer.
  """
  def example_dense_layer do
    mlir_code = """
    %0 = stablehlo.dot_general %input, %weights : tensor<f32>
    %1 = stablehlo.add %0, %bias : tensor<f32>
    """

    axon_model = ExMLIR.to_axon(mlir_code)
    {mlir_code, axon_model}
  end

  @doc """
  Example: Convert StableHLO convolution to Axon.
  """
  def example_conv_layer do
    mlir_code = """
    %0 = stablehlo.convolution %input, %filter {
      window_strides = [1, 1],
      padding = [[0, 0], [0, 0]]
    } : (tensor<f32>, tensor<f32>) -> tensor<f32>
    """

    axon_model = ExMLIR.to_axon(mlir_code)
    {mlir_code, axon_model}
  end
end

