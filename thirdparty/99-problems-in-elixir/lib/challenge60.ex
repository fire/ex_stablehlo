defmodule Challenge60 do
  @moduledoc """
     (**) Construct height-balanced binary trees with a given number of nodes
    Consider a height-balanced binary tree of height H. What is the maximum number of nodes it can contain?
    Clearly, MAXN = 2**H - 1. However, what is the minimum number MINN? This question is more difficult.
    Try to find a recursive statement and turn it into a function minnodes defined as follows:

    (min-nodes H) returns the minimum number of nodes in a height-balanced binary tree of height H.


    On the other hand, we might ask: what is the maximum height H a height-balanced binary tree with N nodes can have?
    (max-height N) returns the maximum height of a height-balanced binary tree with N nodes

    Now, we can attack the main problem: construct all the height-balanced binary trees with a given number of nodes.
    (hbal-tree-nodes N) returns all height-balanced binary trees with N nodes.

    Find out how many height-balanced trees exist for N = 15.
  """

  def min_nodes(0), do: 0
  def min_nodes(1), do: 1

  def min_nodes(h) do
    min_nodes(h - 1) + min_nodes(h - 2) + 1
  end

  def max_height(0), do: 0
  def max_height(1), do: 1

  def max_height(nodes_count) do
    max_height_impl(0, nodes_count)
  end

  defp max_height_impl(cur_height, nodes_count) do
    mn = min_nodes(cur_height)

    if mn <= nodes_count do
      max_height_impl(cur_height + 1, nodes_count)
    else
      cur_height - 1
    end
  end

  def hbal_tree_nodes(nodes_count) do
    maxh = max_height(nodes_count)

    Enum.flat_map(0..maxh, fn h ->
      Challenge59.hbal_tree(h) |> Enum.filter(&(TreeNode.count_nodes_in_tree(&1) == nodes_count))
    end)
  end
end
