defmodule Challenge71 do
  @moduledoc """
    (*) Determine the internal path length of a tree

      We define the internal path length of a multiway tree as the total sum of the path lengths from the root
      to all nodes of the tree. By this definition, the tree in the figure of problem P70 has an internal path
      length of 9.
      Write a function (ipl tree) to compute it.
  """

  def ipl(t, counter\\0)

  def ipl([_root|tail], counter) do
    counter + Enum.sum(Enum.map(tail, fn x -> ipl(x, counter+1) end))
  end

  def ipl(_elem, counter), do: counter
end
