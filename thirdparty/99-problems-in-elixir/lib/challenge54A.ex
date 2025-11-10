defmodule Challenge54A do
  @moduledoc """
  (*) Check whether a given expression represents a binary tree
  Write a function istree which returns true if and only if its argument is a list representing a binary tree.
  """
  def is_tree(nil), do: true

  def is_tree([root, l, r]) when root != nil and is_atom(root) do
    is_tree(l) && is_tree(r)
  end

  def is_tree(_), do: false
end
