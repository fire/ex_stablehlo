defmodule ExMLIR.Examples.Arithmetic do
  @moduledoc """
  Examples of converting arithmetic operations between Elixir and MLIR.

  Demonstrates the `arith` dialect for basic arithmetic operations.
  """

  alias ExMLIR

  @doc """
  Example: Simple addition function.
  """
  def example_addition do
    elixir_code = """
    defn add(a, b) do
      Nx.add(a, b)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    elixir_back = ExMLIR.to_elixir(mlir_code)

    {elixir_code, mlir_code, elixir_back}
  end

  @doc """
  Example: Multiple arithmetic operations.
  """
  def example_multiple_ops do
    elixir_code = """
    defn compute(a, b, c) do
      sum = Nx.add(a, b)
      product = Nx.multiply(sum, c)
      result = Nx.subtract(product, Nx.tensor(10))
      result
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Complex arithmetic expression (quadratic formula).
  """
  def example_quadratic do
    elixir_code = """
    defn quadratic(a, b, c, x) do
      x_squared = Nx.multiply(x, x)
      ax_squared = Nx.multiply(a, x_squared)
      bx = Nx.multiply(b, x)
      ax_squared_plus_bx = Nx.add(ax_squared, bx)
      Nx.add(ax_squared_plus_bx, c)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    elixir_back = ExMLIR.to_elixir(mlir_code)

    {elixir_code, mlir_code, elixir_back}
  end

  @doc """
  Example: Bitwise operations.
  """
  def example_bitwise do
    elixir_code = """
    defn bitwise_ops(a, b) do
      and_result = Nx.bitwise_and(a, b)
      or_result = Nx.bitwise_or(a, b)
      xor_result = Nx.bitwise_xor(a, b)
      Nx.add(and_result, Nx.add(or_result, xor_result))
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Comparison operations.
  """
  def example_comparisons do
    elixir_code = """
    defn compare_values(a, b) do
      greater = Nx.greater(a, b)
      less = Nx.less(a, b)
      equal = Nx.equal(a, b)
      Nx.add(greater, Nx.add(less, equal))
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  MLIR representation of basic arithmetic operations.
  """
  def mlir_arithmetic do
    """
    func.func @add(%arg0: i32, %arg1: i32) -> i32 {
      %0 = arith.addi %arg0, %arg1 : i32
      return %0 : i32
    }

    func.func @multiply(%arg0: i32, %arg1: i32) -> i32 {
      %0 = arith.muli %arg0, %arg1 : i32
      return %0 : i32
    }

    func.func @subtract(%arg0: i32, %arg1: i32) -> i32 {
      %0 = arith.subi %arg0, %arg1 : i32
      return %0 : i32
    }

    func.func @divide(%arg0: i32, %arg1: i32) -> i32 {
      %0 = arith.divi %arg0, %arg1 : i32
      return %0 : i32
    }
    """
  end

  @doc """
  MLIR representation of bitwise operations.
  """
  def mlir_bitwise do
    """
    func.func @bitwise_ops(%a: i32, %b: i32) -> i32 {
      %and_result = arith.andi %a, %b : i32
      %or_result = arith.ori %a, %b : i32
      %xor_result = arith.xori %a, %b : i32
      %sum1 = arith.addi %and_result, %or_result : i32
      %result = arith.addi %sum1, %xor_result : i32
      return %result : i32
    }
    """
  end

  @doc """
  MLIR representation of complex arithmetic expression.
  """
  def mlir_quadratic do
    """
    func.func @quadratic(%a: f32, %b: f32, %c: f32, %x: f32) -> f32 {
      %x_squared = arith.mulf %x, %x : f32
      %ax_squared = arith.mulf %a, %x_squared : f32
      %bx = arith.mulf %b, %x : f32
      %ax_squared_plus_bx = arith.addf %ax_squared, %bx : f32
      %result = arith.addf %ax_squared_plus_bx, %c : f32
      return %result : f32
    }
    """
  end
end

