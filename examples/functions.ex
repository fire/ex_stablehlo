defmodule ExMLIR.Examples.Functions do
  @moduledoc """
  Examples of converting function definitions and calls between Elixir and MLIR.

  Demonstrates the `func` dialect for function operations.
  """

  alias ExMLIR

  @doc """
  Example: Function composition with multiple calls.
  """
  def example_function_composition do
    elixir_code = """
    defn square(x) do
      Nx.multiply(x, x)
    end

    defn add_squares(a, b) do
      square_a = square(a)
      square_b = square(b)
      Nx.add(square_a, square_b)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Nested function calls.
  """
  def example_nested_calls do
    elixir_code = """
    defn double(x) do
      Nx.multiply(x, Nx.tensor(2))
    end

    defn quadruple(x) do
      double(double(x))
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Helper functions.
  """
  def example_helper_functions do
    elixir_code = """
    defn helper_add(a, b) do
      Nx.add(a, b)
    end

    defn helper_multiply(a, b) do
      Nx.multiply(a, b)
    end

    defn compute(a, b, c) do
      sum = helper_add(a, b)
      helper_multiply(sum, c)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  MLIR representation of function definitions and calls.
  """
  def mlir_functions do
    """
    func.func @square(%x: i32) -> i32 {
      %result = arith.muli %x, %x : i32
      return %result : i32
    }

    func.func @add_squares(%a: i32, %b: i32) -> i32 {
      %square_a = func.call @square(%a) : (i32) -> i32
      %square_b = func.call @square(%b) : (i32) -> i32
      %result = arith.addi %square_a, %square_b : i32
      return %result : i32
    }

    func.func @double(%x: i32) -> i32 {
      %two = arith.constant 2 : i32
      %result = arith.muli %x, %two : i32
      return %result : i32
    }

    func.func @quadruple(%x: i32) -> i32 {
      %doubled = func.call @double(%x) : (i32) -> i32
      %result = func.call @double(%doubled) : (i32) -> i32
      return %result : i32
    }
    """
  end

  @doc """
  MLIR representation of helper function pattern.
  """
  def mlir_helper_functions do
    """
    func.func private @helper_add(%a: i32, %b: i32) -> i32 {
      %result = arith.addi %a, %b : i32
      return %result : i32
    }

    func.func private @helper_multiply(%a: i32, %b: i32) -> i32 {
      %result = arith.muli %a, %b : i32
      return %result : i32
    }

    func.func @compute(%a: i32, %b: i32, %c: i32) -> i32 {
      %sum = func.call @helper_add(%a, %b) : (i32, i32) -> i32
      %result = func.call @helper_multiply(%sum, %c) : (i32, i32) -> i32
      return %result : i32
    }
    """
  end
end

