defmodule Challenge72 do
  @moduledoc """
    (*) Construct the bottom-up order sequence of the tree nodes
    Write a function (bottom-up mtree) which returns the bottom-up sequence of the nodes
    of the multiway tree mtree as a Lisp list.
  """

  def bottom_up([h | tail]) do
    Enum.concat(Enum.map(tail, &bottom_up(&1))) ++ [h]
  end

  def bottom_up([]), do: []

  def bottom_up(elem), do: [elem]
end
