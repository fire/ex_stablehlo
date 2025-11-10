defmodule Challenge62 do
  @moduledoc """
    (*) Collect the internal nodes of a binary tree in a list
        An internal node of a binary tree has either one or two non-empty successors. Write a function internals to collect them in a list.

        (internals tree) returns the list of internal nodes of the binary tree tree.
  """
  def internals(tree) do
    cond do
      is_nil(tree) -> []
      TreeNode.is_leaf(tree) -> []
      true -> [tree] ++ internals(tree.left) ++ internals(tree.right)
    end
  end
end
