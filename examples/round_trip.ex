defmodule ExMLIR.Examples.RoundTrip do
  @moduledoc """
  Examples demonstrating round-trip conversion between Elixir and MLIR.

  Shows that conversions preserve semantics even if syntax differs.
  """

  alias ExMLIR

  @doc """
  Example: Complete round-trip conversion.
  """
  def example_round_trip do
    original_elixir = """
    defn calculate(a, b) do
      sum = Nx.add(a, b)
      product = Nx.multiply(sum, Nx.tensor(2))
      Nx.subtract(product, Nx.tensor(1))
    end
    """

    # Elixir -> MLIR
    mlir = ExMLIR.from_elixir(original_elixir)

    # MLIR -> Elixir
    elixir_back = ExMLIR.to_elixir(mlir)

    {original_elixir, mlir, elixir_back}
  end

  @doc """
  Example: MLIR to Nx conversion.
  """
  def example_mlir_to_nx do
    mlir_code = """
    func.func @compute(%arg0: i32, %arg1: i32, %arg2: i32) -> i32 {
      %0 = arith.addi %arg0, %arg1 : i32
      %1 = arith.muli %0, %arg2 : i32
      %2 = arith.subi %1, %c10_i32 : i32
      return %2 : i32
    }
    """

    # Convert to Nx
    nx_code = ExMLIR.to_elixir(mlir_code)
    {mlir_code, nx_code}
  end

  @doc """
  Example: Multiple round-trips to verify stability.
  """
  def example_multiple_round_trips do
    original = """
    defn simple_add(a, b) do
      Nx.add(a, b)
    end
    """

    # First conversion
    mlir1 = ExMLIR.from_elixir(original)
    elixir1 = ExMLIR.to_elixir(mlir1)

    # Second conversion
    mlir2 = ExMLIR.from_elixir(elixir1)
    elixir2 = ExMLIR.to_elixir(mlir2)

    {original, mlir1, elixir1, mlir2, elixir2}
  end

  @doc """
  Example: Complex expression round-trip.
  """
  def example_complex_round_trip do
    original = """
    defn complex_expr(x, y, z) do
      xy = Nx.multiply(x, y)
      xyz = Nx.multiply(xy, z)
      sum = Nx.add(xyz, Nx.tensor(100))
      Nx.divide(sum, Nx.tensor(2))
    end
    """

    mlir = ExMLIR.from_elixir(original)
    elixir_back = ExMLIR.to_elixir(mlir)

    {original, mlir, elixir_back}
  end
end

