defmodule Challenge47 do
  @moduledoc """
    (*) Truth tables for logical expressions (2).
        Modify problem P46 by accepting expressions written in infix notation, with all parenthesis present.
        This allows us to write logical expression in a more natural way, as in the example: (A and (A or (not B))).

        Example:
        * (table 'A 'B '(A and (A or (not B)))).
        true true true
        true nil true
        nil true nil
        nil nil nil
  """

  # or
  def a ||| b, do: a || b
  # and
  def a &&& b, do: a && b
  # impl
  def a +++ b, do: Challenge46.tbl_impl(a, b)
  # xor
  def a <~> b, do: Challenge46.tbl_xor(a, b)

  def table(input_fn) do
    for a <- [true, false],
        b <- [true, false],
        do: "#{a} #{b} #{input_fn.(a, b)}"
  end
end
