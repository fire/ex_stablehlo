defmodule Challenge68 do
  @moduledoc """
  (**) Preorder and inorder sequences of binary trees
     We consider binary trees with nodes that are identified by single lower-case letters, as in the example of problem P67.

     a) Write functions preorder and inorder that construct the preorder and inorder sequence of a given binary tree, respectively.
     The results should be lists, e.g. (A B D E C F G) for the preorder sequence of the example in problem P67.

     b) Can you write the inverse of preorder from problem part a) ; i.e. given a preorder sequence, construct a corresponding tree?

     c) If both the preorder sequence and the inorder sequence of the nodes of a binary tree are given,
     then the tree is determined unambiguously. Write a function pre-in-tree that does the job.
  """
  def preorder_and_inorder_to_tree(pre_seq, in_seq) when is_nil(pre_seq) or is_nil(in_seq),
    do: nil

  def preorder_and_inorder_to_tree(pre_seq, in_seq) do
    pre_node_names = pre_seq |> String.graphemes()
    in_node_names = in_seq |> String.graphemes()

    split_inorder_nodes_fn = fn in_node_names, seed_node_name ->
      if seed_node_name not in in_node_names do
        {[], []}
      else
        {left, right} =
          Enum.split_while(in_node_names, &(&1 != seed_node_name))

        {left, tl(right)}
      end
    end

    create_tree_fn = fn me, pre_node_names, in_node_names ->
      case pre_node_names do
        [] ->
          nil

        [pre_h | pre_tail] ->
          {left_in_node_names, right_in_node_names} =
            split_inorder_nodes_fn.(in_node_names, pre_h)

          pre_for_left = Enum.filter(pre_tail, &(&1 in left_in_node_names))
          pre_for_right = Enum.filter(pre_tail, &(&1 in right_in_node_names))

          %TreeNode{
            symbol: pre_h,
            left: me.(me, pre_for_left, left_in_node_names),
            right: me.(me, pre_for_right, right_in_node_names)
          }
      end
    end

    create_tree_fn.(create_tree_fn, pre_node_names, in_node_names)
  end

  def preorder_sequence_to_tree(_seq) do
    # Having only preorder is not enough to build an unambiguous tree.
    raise("Leads to ambiguous results")
  end

  def preorder(t) do
    cond do
      is_nil(t) ->
        ""

      TreeNode.is_leaf(t) ->
        "#{t.symbol}"

      true ->
        "#{t.symbol}" <> preorder(t.left) <> preorder(t.right)
    end
  end

  def inorder(t) do
    cond do
      is_nil(t) ->
        ""

      TreeNode.is_leaf(t) ->
        "#{t.symbol}"

      true ->
        inorder(t.left) <> "#{t.symbol}" <> inorder(t.right)
    end
  end
end
