defmodule Challenge58 do
  @moduledoc """
   (**) Generate-and-test paradigm
   Apply the generate-and-test paradigm to construct all symmetric, completely balanced binary trees
   with a given number of nodes.
   Example:
   * (sym-cbal-trees-print 5)
   (X (X NIL (X NIL NIL)) (X (X NIL NIL) NIL))
   (X (X (X NIL NIL) NIL) (X NIL (X NIL NIL)))
   ..

    How many such trees are there with 57 nodes?
    Investigate about how many solutions there are for a given number of nodes.
    What if the number is even? Write an appropriate function.
  """

  def sym_cbal_trees(nodes_count) when nodes_count <= 0 or rem(nodes_count, 2) == 0, do: []

  def sym_cbal_trees(nodes_count) do
    # TODO: slow as hell
    nodes_count |> Challenge55.cbal_tree() |> Enum.filter(&Challenge56.is_symmetric/1)
  end
end
