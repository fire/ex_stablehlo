defmodule Challenge66 do
  @moduledoc """
    (***) Layout a binary tree (3)
        Yet another layout strategy is shown in the illustration opposite.
        The method yields a very compact layout while maintaining a certain symmetry in every node.
        Find out the rules and write the corresponding Lisp function.
        Hint: Consider the horizontal distance between a node and its successor nodes.
        How tight can you pack together two subtrees to construct the combined binary tree?

        Use the same conventions as in problem P64 and P65 and test your function in an appropriate way.
        Note: This is a difficult problem. Don't give up too early!

        Which layout do you like most?
  """

  def layout_binary_tree(nil), do: ""
  def layout_binary_tree(t, stepx \\ 5), do: layout_binary_tree_impl(t, stepx, 1)

  defp layout_binary_tree_impl(t, rootx, rooty) do
    format_val = fn val ->
      truncated_val = trunc(val)

      if val - truncated_val == 0, do: truncated_val, else: val
    end

    calc_next_rootx_step = fn cur_rooty ->
      if cur_rooty == 1, do: 2, else: 1
    end

    if TreeNode.is_leaf(t) do
      "(#{t.symbol} #{format_val.(rootx)} #{rooty} nil nil)"
    else
      next_rootx_step = calc_next_rootx_step.(rooty)

      "(" <>
        "#{t.symbol} #{format_val.(rootx)} #{rooty}" <>
        if is_nil(t.left) do
          " nil"
        else
          " " <> layout_binary_tree_impl(t.left, rootx - next_rootx_step, rooty + 1)
        end <>
        if is_nil(t.right) do
          " nil"
        else
          " " <> layout_binary_tree_impl(t.right, rootx + next_rootx_step, rooty + 1)
        end <>
        ")"
    end
  end
end
