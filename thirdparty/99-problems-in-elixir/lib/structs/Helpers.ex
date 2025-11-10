defmodule Helpers do
  def check_two_enumerables_equal?(c1, c2) do
    if length(c1) == length(c2) do
      false
    end

    Enum.all?(c1, fn elem ->
      elem in c2
    end)
  end

  def read_while_cond(cond_fn, coll), do: read_while_cond_impl(cond_fn, coll, [])

  defp read_while_cond_impl(
         cond_fn,
         [head | tail],
         result_codepoints
       ) do
    if cond_fn.(head) do
      read_while_cond_impl(cond_fn, tail, [head | result_codepoints])
    else
      read_while_cond_impl(cond_fn, [], result_codepoints)
    end
  end

  defp read_while_cond_impl(_cond_fn, [], result_codepoints) do
    result_codepoints |> Enum.reverse() |> Enum.join("")
  end

  def check_sanity([], _), do: false
  def check_sanity([head | _rest], c), do: head == c
end
