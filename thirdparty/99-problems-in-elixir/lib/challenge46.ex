defmodule Challenge46 do
  @moduledoc """
    (**) Truth tables for logical expressions. Solutions
    Define predicates and/2, or/2, nand/2, nor/2, xor/2, impl/2 and equ/2 (for logical equivalence)
    which succeed or fail according to the result of their respective operations;
    e.g. and(A,B) will succeed, if and only if both A and B succeed.

    A logical expression in two variables can then be written as in the following example: and(or(A,B),nand(A,B)).
    Now, write a predicate table/3 which prints the truth table of a given logical expression in two variables.
  """
  def table(input_fn) do
    for a <- [true, false],
        b <- [true, false],
        do: "#{a} #{b} #{input_fn.(a, b)}"
  end

  def tbl_impl(a, b) do
    case {a, b} do
      {true, false} -> false
      _ -> true
    end
  end

  def tbl_equ(a, b) do
    case {a, b} do
      {true, true} -> true
      {false, false} -> true
      _ -> false
    end
  end

  def tbl_xor(a, b) do
    case {a, b} do
      {true, true} -> false
      {false, false} -> false
      _ -> true
    end
  end

  def tbl_nor(a, b) do
    !tbl_or(a, b)
  end

  def tbl_nand(a, b) do
    !tbl_and(a, b)
  end

  def tbl_or(a, b) do
    case {a, b} do
      {false, false} -> false
      _ -> true
    end
  end

  def tbl_and(a, b) do
    case {a, b} do
      {true, true} -> true
      _ -> false
    end
  end
end
