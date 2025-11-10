defmodule Challenge69 do
  @moduledoc """
    (**) Dotstring representation of binary trees
        We consider again binary trees with nodes that are identified by single lower-case letters,
        as in the example of problem P67.
        Such a tree can be represented by the preorder sequence of its nodes
        in which dots (.) are inserted where an empty subtree (nil) is encountered during the tree traversal.
        For example, the tree shown in problem P67 is represented as "ABD..E..C.FG...".
        First, try to establish a syntax (BNF or syntax diagrams) and then write functions tree and dotstring
        which do the conversion.
  """

  def dotstring(t) do
    cond do
      is_nil(t) ->
        "."

      TreeNode.is_leaf(t) ->
        "#{t.symbol}.."

      true ->
        "#{t.symbol}" <> dotstring(t.left) <> dotstring(t.right)
    end
  end

  def dotstring_to_tree(ds) do
    ds |> String.graphemes() |> dotstring_to_tree_impl()
  end

  defp dotstring_to_tree_impl([]), do: nil

  defp dotstring_to_tree_impl([head | tail]) do
    tree = %TreeNode{symbol: head}

    dirty_tree =
      Enum.reduce(tail, tree, fn x, acc ->
        {updated_tree, _status} = update_tree_where_appropriate(x, acc)
        updated_tree
      end)

    cleanup_tree_from_dots(dirty_tree)
  end

  defp cleanup_tree_from_dots(tree) do
    if tree.symbol == "." do
      nil
    else
      left = cleanup_tree_from_dots(tree.left)
      right = cleanup_tree_from_dots(tree.right)
      result = TreeNode.with_left(tree, left)
      result = TreeNode.with_right(result, right)
      result
    end
  end

  defp update_tree_where_appropriate(node_name, tree) do
    cond do
      tree.symbol == "." ->
        {tree, false}

      is_nil(tree.left) ->
        {TreeNode.with_left(tree, %TreeNode{symbol: node_name}), true}

      Kernel.elem(
        {updated_tree, _status} = update_tree_where_appropriate(node_name, tree.left),
        1
      ) ->
        {TreeNode.with_left(tree, updated_tree), true}

      is_nil(tree.right) ->
        {TreeNode.with_right(tree, %TreeNode{symbol: node_name}), true}

      Kernel.elem(
        {updated_tree, _status} = update_tree_where_appropriate(node_name, tree.right),
        1
      ) ->
        {TreeNode.with_right(tree, updated_tree), true}

      true ->
        {tree, false}
    end
  end
end
