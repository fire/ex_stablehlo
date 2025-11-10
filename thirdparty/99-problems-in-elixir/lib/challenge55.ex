defmodule Challenge55 do
  @moduledoc """
    (**) Construct completely balanced binary trees
        In a completely balanced binary tree, the following property holds for every node:
        The number of nodes in its left subtree and the number of nodes in its right subtree are almost equal,
        which means their difference is not greater than one.

        Write a function cbal-tree to construct completely balanced binary trees for a given number of nodes.
        The function should generate all solutions. Put the symbol 'x' as information into all nodes of the tree.
        Example:
        * (cbal-tree-print 4)
        (X (X NIL NIL) (X NIL (X NIL NIL)))
        (X (X NIL NIL) (X (X NIL NIL) NIL))
        etc......
  """

  def cbal_tree(0), do: [nil]

  def cbal_tree(count) do
    nodes_list = cbal_tree(count - 1)

    nodes_list
    |> Enum.map(&gen_new_nodes(&1))
    |> Enum.concat()
    |> Enum.filter(&check_condition_is_met/1)
    |> Enum.uniq()
  end

  defp gen_new_nodes(node) do
    cond do
      is_nil(node) ->
        [%TreeNode{symbol: :x, left: nil, right: nil}]

      TreeNode.is_leaf(node) ->
        [
          TreeNode.with_left(node, %TreeNode{symbol: :x, left: nil, right: nil}),
          TreeNode.with_right(node, %TreeNode{symbol: :x, left: nil, right: nil})
        ]

      true ->
        new_left_nodes = gen_new_nodes(node.left)
        new_right_nodes = gen_new_nodes(node.right)

        result_a =
          for new_left_node <- new_left_nodes do
            TreeNode.with_left(node, new_left_node)
          end

        result_b =
          for new_right_node <- new_right_nodes do
            TreeNode.with_right(node, new_right_node)
          end

        Enum.concat(result_a, result_b)
    end
  end

  defp check_condition_is_met(node) do
    is_nil(node) ||
      (abs(TreeNode.count_nodes_in_tree(node.left) - TreeNode.count_nodes_in_tree(node.right)) <= 1 &&
         check_condition_is_met(node.left) && check_condition_is_met(node.right))
  end
end
