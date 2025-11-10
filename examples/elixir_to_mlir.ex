defmodule ExMLIR.Examples.ElixirToMLIR do
  @moduledoc """
  Examples of converting Elixir code to MLIR (StableHLO).
  """

  alias ExMLIR

  @doc """
  Example: Convert Elixir function to MLIR.
  """
  def example_simple_function do
    elixir_code = """
    defn add(a, b) do
      Nx.add(a, b)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Convert Axon model to MLIR.
  """
  def example_axon_model do
    model = Axon.input("input", shape: {nil, 784})
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(10, activation: :softmax)

    mlir_code = ExMLIR.from_axon(model)
    {model, mlir_code}
  end

  @doc """
  Example: Convert complex Axon model to MLIR.
  """
  def example_complex_model do
    model = Axon.input("input", shape: {nil, 28, 28, 1})
    |> Axon.conv(32, kernel_size: {3, 3}, activation: :relu)
    |> Axon.max_pool(kernel_size: {2, 2})
    |> Axon.flatten()
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(10, activation: :softmax)

    mlir_code = ExMLIR.from_axon(model)
    {model, mlir_code}
  end
end

