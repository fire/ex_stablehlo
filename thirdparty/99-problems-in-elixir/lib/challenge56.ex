defmodule Challenge56 do
  @moduledoc """
    (**) Symmetric binary trees
       Let us call a binary tree symmetric if you can draw a vertical line through the root node and then the right subtree
       is the mirror image of the left subtree. Write a function symmetric to check whether a given binary tree is symmetric.
       We are only interested in the structure, not in the contents of the nodes.
  """
  def is_symmetric(node), do: is_symmetric_helper(node, node)

  defp is_symmetric_helper(a, b) do
    cond do
      is_nil(a) -> is_nil(b)
      is_nil(b) -> is_nil(a)
      TreeNode.is_leaf(a) -> TreeNode.is_leaf(b)
      TreeNode.is_leaf(b) -> TreeNode.is_leaf(a)
      true -> is_symmetric_helper(a.left, b.right) && is_symmetric_helper(a.right, b.left)
    end
  end
end
