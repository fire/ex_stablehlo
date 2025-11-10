defmodule ExMLIR.Examples.AxonModels do
  @moduledoc """
  Examples of converting Axon models to MLIR.

  Demonstrates conversion of neural network models.
  """

  alias ExMLIR

  @doc """
  Example: Simple Axon model conversion.
  """
  def example_simple_model do
    model = Axon.input("input", shape: {nil, 784})
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(10, activation: :softmax)

    mlir_code = ExMLIR.from_axon(model)
    {model, mlir_code}
  end

  @doc """
  Example: Convolutional model.
  """
  def example_conv_model do
    model = Axon.input("input", shape: {nil, 28, 28, 1})
    |> Axon.conv(32, kernel_size: {3, 3}, activation: :relu)
    |> Axon.max_pool(kernel_size: {2, 2})
    |> Axon.flatten()
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(10, activation: :softmax)

    mlir_code = ExMLIR.from_axon(model)
    {model, mlir_code}
  end

  @doc """
  MLIR representation of a simple dense layer.
  """
  def mlir_dense_layer do
    """
    func.func @dense_layer(%input: memref<?x784xf32>, %weights: memref<784x128xf32>, %bias: memref<128xf32>) -> memref<?x128xf32> {
      %output = memref.alloc() : memref<?x128xf32>
      // Matrix multiplication: output = input @ weights
      // Add bias
      // Apply activation (relu)
      return %output : memref<?x128xf32>
    }
    """
  end

  @doc """
  MLIR representation of a convolutional layer.
  """
  def mlir_conv_layer do
    """
    func.func @conv_layer(%input: memref<?x28x28x1xf32>, %filter: memref<3x3x1x32xf32>) -> memref<?x26x26x32xf32> {
      %output = memref.alloc() : memref<?x26x26x32xf32>
      // Convolution operation with sliding window
      // Apply activation
      return %output : memref<?x26x26x32xf32>
    }
    """
  end
end

