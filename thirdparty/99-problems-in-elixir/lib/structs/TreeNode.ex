defmodule TreeNode do
  defstruct symbol: nil, left: nil, right: nil

  def is_leaf(node) do
    is_nil(node.left) && is_nil(node.right)
  end

  def with_left(node, l) do
    %TreeNode{node | left: l}
  end

  def with_right(node, r) do
    %TreeNode{node | right: r}
  end

  def count_nodes_in_tree(node) do
    if is_nil(node),
      do: 0,
      else: 1 + count_nodes_in_tree(node.left) + count_nodes_in_tree(node.right)
  end
end
