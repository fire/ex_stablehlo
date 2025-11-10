defmodule Challenge59 do
  @moduledoc """
    (**) Construct height-balanced binary trees
    In a height-balanced binary tree, the following property holds for every node:
    The height of its left subtree and the height of its right subtree are almost equal,
      which means their difference is not greater than one.

    Write a function hbal-tree to construct height-balanced binary trees for a given height.
    The function should generate all solutions.
    Put the letter 'x' as information into all nodes of the tree.

    Example:
    * (hbal-tree 3)
    (X (X (X NIL NIL) (X NIL NIL)) (X (X NIL NIL) (X NIL NIL)))
    = (X (X (X NIL NIL) (X NIL NIL)) (X (X NIL NIL) NIL))
    etc...
  """

  def hbal_tree(0), do: [nil]

  def hbal_tree(h) do
    nodes_list = hbal_tree(h - 1)

    nodes_list
    |> Enum.map(&gen_new_nodes(&1))
    |> Enum.concat()
    |> Enum.filter(&check_condition_is_met/1)
  end

  def gen_new_nodes(node) do
    cond do
      is_nil(node) ->
        [%TreeNode{symbol: :x, left: nil, right: nil}]

      TreeNode.is_leaf(node) ->
        [
          TreeNode.with_left(node, %TreeNode{symbol: :x, left: nil, right: nil}),
          TreeNode.with_right(node, %TreeNode{symbol: :x, left: nil, right: nil}),
          TreeNode.with_left(node, %TreeNode{symbol: :x, left: nil, right: nil})
          |> TreeNode.with_right(%TreeNode{symbol: :x, left: nil, right: nil})
        ]

      true ->
        new_left_nodes = gen_new_nodes(node.left)
        new_right_nodes = gen_new_nodes(node.right)

        for new_left_node <- new_left_nodes,
            new_right_node <- new_right_nodes do
          TreeNode.with_left(node, new_left_node)
          |> TreeNode.with_right(new_right_node)
        end
    end
  end

  defp check_condition_is_met(node) do
    abs(tree_height(node.left) - tree_height(node.right)) <= 1
  end

  defp tree_height(node) do
    if is_nil(node),
      do: 0,
      else: 1 + max(tree_height(node.left), tree_height(node.right))
  end
end
