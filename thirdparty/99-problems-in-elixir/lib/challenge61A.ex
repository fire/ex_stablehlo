defmodule Challenge61A do
  @moduledoc """
    (*) Collect the leaves of a binary tree in a list
        A leaf is a node with no successors. Write a function leaves to return them in a list.

        (leaves tree) returns the list of all leaves of the binary tree tree
  """
  def leaves(tree) do
    cond do
      is_nil(tree) -> []
      TreeNode.is_leaf(tree) -> [tree]
      true -> leaves(tree.left) ++ leaves(tree.right)
    end
  end
end
