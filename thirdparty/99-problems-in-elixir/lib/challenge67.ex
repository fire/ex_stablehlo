defmodule Challenge67 do
  @moduledoc """
  (**) A string representation of binary trees
     Somebody represents binary trees as strings of the following type (see example opposite):
     a(b(d,e),c(,f(g,)))
     a) Write a Lisp function which generates this string representation, if the tree is given as usual (as nil or (X L R) expression).
     Then write a function which does this inverse; i.e. given the string representation, construct the tree in the usual form.
  """

  def string_repr_to_tree(nil), do: nil

  def string_repr_to_tree(string_repr) do
    {tree_result, processed_symbols_count} =
      string_repr |> String.codepoints() |> string_repr_to_tree_impl()

    if processed_symbols_count != String.length(string_repr) do
      raise("Invalid format!")
    else
      tree_result
    end
  end

  defp string_repr_to_tree_impl(src_list) do
    tree_name =
      Helpers.read_while_cond(
        fn letter -> String.match?(letter, ~r/^[a-zA-Z0-9]$/i) end,
        src_list
      )

    len_name = String.length(tree_name)

    if len_name == 0 do
      # no tree
      {nil, 0}
    else
      cnt = len_name
      src_list = Enum.drop(src_list, len_name)

      # open bracket of tree
      if Helpers.check_sanity(src_list, "(") do
        cnt = cnt + 1
        src_list = Enum.drop(src_list, 1)

        # parse optional left node
        {optional_left_node, optional_left_node_len} = string_repr_to_tree_impl(src_list)
        cnt = cnt + optional_left_node_len
        src_list = Enum.drop(src_list, optional_left_node_len)

        if !Helpers.check_sanity(src_list, ",") do
          IO.puts(src_list)
          IO.puts(optional_left_node_len)
          raise("Expected ,")
        end

        # skip ","
        cnt = cnt + 1
        src_list = Enum.drop(src_list, 1)

        # parse optional right node
        {optional_right_node, optional_right_node_len} = string_repr_to_tree_impl(src_list)
        cnt = cnt + optional_right_node_len
        src_list = Enum.drop(src_list, optional_right_node_len)

        if is_nil(optional_left_node) && is_nil(optional_right_node) do
          raise("At least one inner node expected: either left left or right)")
        end

        # closed bracket of tree
        if !Helpers.check_sanity(src_list, ")") do
          raise("Expected )")
        end

        cnt = cnt + 1

        {%TreeNode{symbol: tree_name, left: optional_left_node, right: optional_right_node}, cnt}
      else
        {%TreeNode{symbol: tree_name, left: nil, right: nil}, cnt}
      end
    end
  end

  def tree_to_string_repr(tree) do
    cond do
      is_nil(tree) ->
        ""

      TreeNode.is_leaf(tree) ->
        "#{tree.symbol}"

      true ->
        "#{tree.symbol}" <>
          "(" <>
          if !is_nil(tree.left) do
            tree_to_string_repr(tree.left)
          else
            ""
          end <>
          "," <>
          if !is_nil(tree.right) do
            tree_to_string_repr(tree.right)
          else
            ""
          end <> ")"
    end
  end
end
