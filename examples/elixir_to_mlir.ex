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
  Example: Convert Elixir/Nx function to MLIR.
  """
  def example_nx_function do
    elixir_code = """
    defn dense(input, weights, bias) do
      Nx.dot(input, weights)
      |> Nx.add(bias)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Convert complex Elixir/Nx computation to MLIR.
  """
  def example_complex_computation do
    elixir_code = """
    defn conv2d(input, filter) do
      Nx.conv(input, filter, padding: :same)
    end

    defn mlp(input, w1, b1, w2, b2) do
      input
      |> Nx.dot(w1)
      |> Nx.add(b1)
      |> Nx.relu()
      |> Nx.dot(w2)
      |> Nx.add(b2)
      |> Nx.softmax()
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end
end

