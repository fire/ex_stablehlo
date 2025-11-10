defmodule Challenge62B do
  @moduledoc """
    (*) Collect the nodes at a given level in a list
       A node of a binary tree is at level N if the path from the root to the node has length N-1.
       The root node is at level 1. Write a function atlevel to collect all nodes at a given level in a list.

       (atlevel tree l) returns the list of nodes of the binary tree tree at level L
  """
  def atlevel(_tree, l) when l <= 0, do: []

  def atlevel(tree, _l) when is_nil(tree), do: []

  def atlevel(tree, l), do: atlevel_helper(tree, l, 1)

  defp atlevel_helper(tree, l, current_level) when current_level == l, do: [tree]

  defp atlevel_helper(tree, l, current_level) do
    cond do
      is_nil(tree) ->
        []

      TreeNode.is_leaf(tree) ->
        []

      true ->
        Enum.concat(
          atlevel_helper(tree.left, l, current_level + 1),
          atlevel_helper(tree.right, l, current_level + 1)
        )
    end
  end
end
