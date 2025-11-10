defmodule ExMLIR.Examples.ControlFlow do
  @moduledoc """
  Examples of converting control flow operations between Elixir and MLIR.

  Demonstrates the `scf` dialect for structured control flow.
  """

  alias ExMLIR

  @doc """
  Example: Conditional operations using if/else.
  """
  def example_conditional do
    elixir_code = """
    defn max_value(a, b) do
      if Nx.greater(a, b) do
        a
      else
        b
      end
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Loop operations using Enum.reduce.
  """
  def example_loop do
    elixir_code = """
    defn sum_range(n) do
      Enum.reduce(0..n, 0, fn i, acc ->
        Nx.add(acc, i)
      end)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: While loop pattern.
  """
  def example_while do
    elixir_code = """
    defn factorial(n) do
      Stream.iterate({1, 1}, fn {acc, i} ->
        if i <= n do
          {Nx.multiply(acc, i), Nx.add(i, 1)}
        else
          {acc, i}
        end
      end)
      |> Enum.find(fn {_acc, i} -> i > n end)
      |> elem(0)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  MLIR representation of conditional operations using scf.if.
  """
  def mlir_conditional do
    """
    func.func @max(%arg0: i32, %arg1: i32) -> i32 {
      %cmp = arith.cmpi sgt, %arg0, %arg1 : i32
      %result = scf.if %cmp -> (i32) {
        scf.yield %arg0 : i32
      } else {
        scf.yield %arg1 : i32
      }
      return %result : i32
    }

    func.func @min(%arg0: i32, %arg1: i32) -> i32 {
      %cmp = arith.cmpi slt, %arg0, %arg1 : i32
      %result = scf.if %cmp -> (i32) {
        scf.yield %arg0 : i32
      } else {
        scf.yield %arg1 : i32
      }
      return %result : i32
    }
    """
  end

  @doc """
  MLIR representation of loop operations using scf.for.
  """
  def mlir_loops do
    """
    func.func @sum_range(%n: i32) -> i32 {
      %zero = arith.constant 0 : i32
      %one = arith.constant 1 : i32
      %n_plus_one = arith.addi %n, %one : i32
      %result = scf.for %i = %zero to %n_plus_one step %one iter_args(%acc = %zero) -> (i32) {
        %new_acc = arith.addi %acc, %i : i32
        scf.yield %new_acc : i32
      }
      return %result : i32
    }

    func.func @factorial(%n: i32) -> i32 {
      %one = arith.constant 1 : i32
      %two = arith.constant 2 : i32
      %n_plus_one = arith.addi %n, %one : i32
      %result = scf.for %i = %two to %n_plus_one step %one iter_args(%acc = %one) -> (i32) {
        %new_acc = arith.muli %acc, %i : i32
        scf.yield %new_acc : i32
      }
      return %result : i32
    }
    """
  end

  @doc """
  MLIR representation of while loop using scf.while.
  """
  def mlir_while do
    """
    func.func @gcd(%a: i32, %b: i32) -> i32 {
      %zero = arith.constant 0 : i32
      %result = scf.while (%arg_a = %a, %arg_b = %b) : (i32, i32) -> (i32) {
        %rem = arith.remui %arg_a, %arg_b : i32
        %cmp = arith.cmpi ne, %rem, %zero : i32
        scf.condition %cmp (%arg_a, %arg_b)
      } do {
        %rem = arith.remui %arg_a, %arg_b : i32
        scf.yield (%arg_b, %rem) : (i32, i32)
      }
      return %result : i32
    }
    """
  end
end

