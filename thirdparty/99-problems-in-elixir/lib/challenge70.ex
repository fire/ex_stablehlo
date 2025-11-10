defmodule Challenge70 do
  @moduledoc """
    (*) Check whether a given expression represents a multiway tree
        Write a function istree which succeeds if and only if its argument is a Lisp expression representing a multiway tree.
        Example:
        * (istree '(a (f g) c (b d e)))
        T

    (*) Count the nodes of a multiway tree
        Write a function nnodes which counts the nodes of a given multiway tree.
        Example:
        * (nnodes '(a f))
        2

    (**) Tree construction from a node string
        We suppose that the nodes of a multiway tree contain single characters. In the depth-first order sequence of its nodes,
        a special character ^ has been inserted whenever, during the tree traversal, the move is a backtrack to the previous level.

        By this rule, the tree in the figure opposite is represented as: afg^^c^bd^e^^^

        Define the syntax of the string and write a function (tree string) to construct the tree when the string is given.
        Work with lists (instead of strings). Write also an inverse function.
  """

  def repr_to_mtree(repr) do
    graphemes = String.graphemes(repr)

    result =
      graphemes
      |> Enum.reduce({[], 0}, fn x, {acc_result, level} ->
        case x == "^" do
          true ->
            acc_result =
              case is_list(List.last(acc_result)) do
                true ->
                  last_elem = List.last(acc_result) |> List.flatten()

                  last_elem =
                    if length(last_elem) == 1, do: List.first(last_elem), else: last_elem

                  List.replace_at(acc_result, -1, last_elem)

                _ ->
                  acc_result
              end

            {acc_result, level - 1}

          _ ->
            acc_result =
              cond do
                level == 0 ->
                  [x]

                level == 1 ->
                  acc_result ++ [[x]]

                true ->
                  List.replace_at(acc_result, -1, List.last(acc_result) ++ [[x]])
              end

            {acc_result, level + 1}
        end
      end)
      |> Kernel.elem(0)

    if length(result) == 1, do: List.first(result), else: result
  end

  def mtree_to_repr(mtree, backtrack \\ true)

  def mtree_to_repr(mtree, _backtrack) when is_list(mtree) do
    result_str =
      mtree
      |> Enum.with_index(1)
      |> Enum.map(fn {key, index} ->
        [mtree_to_repr(key, index > 1)]
      end)
      |> Enum.join("")

    result_str <> "^"
  end

  def mtree_to_repr(mtree, backtrack) do
    "#{mtree}" <> if(backtrack, do: "^", else: "")
  end

  def nnodes(t = [_a, _b | _tail]) do
    t |> Enum.sum_by(&nnodes/1)
  end

  def nnodes(_a), do: 1

  def is_tree(t = [_a, _b | _tail]), do: Enum.all?(t, fn x -> is_root(x) || is_tree(x) end)
  def is_tree(a), do: is_root(a)
  defp is_root(a), do: is_atom(a) && !is_nil(a)
end
