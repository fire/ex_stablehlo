defmodule Challenge64 do
  @moduledoc """
    (**) Layout a binary tree (1)
        Consider a binary tree as the usual symbolic expression (X L R) or nil.
        As a preparation for drawing the tree, a layout algorithm is required to determine the position
        of each node in a rectangular grid. Several layout methods are conceivable, one of them is shown in the illustration below.

        In this layout strategy, the position of a node v is obtained by the following two rules:
            x(v) is equal to the position of the node v in the inorder sequence
            y(v) is equal to the depth of the node v in the tree

        In order to store the position of the nodes, we extend the symbolic expression representing a node (and its successors) as follows:
        nil represents the empty tree (as usual)
        (W X Y L R) represents a (non-empty) binary tree with root W "positioned" at (X,Y), and subtrees L and R

        Write a function layout-binary-tree with the following specification:
        (layout-binary-tree tree) returns the "positioned" binary tree obtained from the binary tree tree
        Test your function in an appropriate way.
  """

  def layout_binary_tree(nil), do: ""

  def layout_binary_tree(tree) do
    map_of_levels = calc_map_of_tree_node_levels(tree) |> Map.new()
    map_of_indexes = Enum.with_index(calc_map_of_tree_nodes_inorder_indexes(tree)) |> Map.new()
    construct_result_str(tree, map_of_levels, map_of_indexes)
  end

  defp construct_result_str(tree, map_of_levels, map_of_indexes) do
    cond do
      is_nil(tree) ->
        "nil"

      TreeNode.is_leaf(tree) ->
        "(#{tree.symbol} #{map_of_indexes[tree.symbol]} #{map_of_levels[tree.symbol]} nil nil)"

      true ->
        left_nodes_str = construct_result_str(tree.left, map_of_levels, map_of_indexes)
        right_nodes_str = construct_result_str(tree.right, map_of_levels, map_of_indexes)

        "(#{tree.symbol} #{map_of_indexes[tree.symbol]} #{map_of_levels[tree.symbol]} #{left_nodes_str} #{right_nodes_str})"
    end
  end

  defp calc_map_of_tree_node_levels(tree, level \\ 1) do
    cond do
      is_nil(tree) ->
        []

      TreeNode.is_leaf(tree) ->
        [{tree.symbol, level}]

      true ->
        Enum.concat([
          [{tree.symbol, level}],
          calc_map_of_tree_node_levels(tree.left, level + 1),
          calc_map_of_tree_node_levels(tree.right, level + 1)
        ])
    end
  end

  defp calc_map_of_tree_nodes_inorder_indexes(tree) do
    cond do
      is_nil(tree) ->
        []

      TreeNode.is_leaf(tree) ->
        [tree.symbol]

      true ->
        Enum.concat([
          calc_map_of_tree_nodes_inorder_indexes(tree.left),
          [tree.symbol],
          calc_map_of_tree_nodes_inorder_indexes(tree.right)
        ])
    end
  end
end
