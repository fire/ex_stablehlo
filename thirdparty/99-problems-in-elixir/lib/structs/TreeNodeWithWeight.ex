defmodule TreeNodeWithWeight do
  defstruct symbol: nil, weight: nil, left: nil, right: nil

  def is_leaf(node) do
    is_nil(node.left) && is_nil(node.right)
  end

  def with_left(node, l) do
    %TreeNodeWithWeight{node | left: l}
  end

  def with_right(node, r) do
    %TreeNodeWithWeight{node | right: r}
  end
end
