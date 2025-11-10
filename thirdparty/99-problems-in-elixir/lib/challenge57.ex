defmodule Challenge57 do
  @moduledoc """
    (**) Binary search trees (dictionaries)
        Write a function to construct a binary search tree from a list of integer numbers.
        Example:
        * (construct '(3 2 5 7 1))
        (3 (2 (1 nil nil) nil) (5 nil (7 nil nil)))

        Then use this function to test the solution of the problem P56.
        Example:
        * (symmetric '(5 3 18 1 4 12 21))
        T
        * (symmetric '(3 2 5 7 1))
        T
        * (symmetric '(3 2 5 7))
        NIL
  """
  def construct([]), do: nil

  def construct([x]) do
    %TreeNode{symbol: x, left: nil, right: nil}
  end

  def construct([head | tail]) do
    root_node = %TreeNode{symbol: head, left: nil, right: nil}
    construct_leafs(root_node, tail)
  end

  defp construct_leafs(result_node, []), do: result_node

  defp construct_leafs(result_node, [cur_val | tail]) do
    new_node = %TreeNode{symbol: cur_val, left: nil, right: nil}
    result_node = gen_node(result_node, new_node)
    construct_leafs(result_node, tail)
  end

  defp gen_node(parent_node, new_node) do
    cond do
      is_nil(parent_node) ->
        new_node

      new_node.symbol <= parent_node.symbol ->
        new_left_node = gen_node(parent_node.left, new_node)
        TreeNode.with_left(parent_node, new_left_node)

      true ->
        new_right_node = gen_node(parent_node.right, new_node)
        TreeNode.with_right(parent_node, new_right_node)
    end
  end
end
