defmodule Challenge26 do
  @moduledoc """
  (**) Generate combinations of K distinct objects chosen from the N elements of a list.
  """

  def combinations(k, lst) when k <= 0 or k > length(lst), do: []

  def combinations(k, lst) do
    combinations_helper(k, lst, []) |> our_reduce()
  end

  defp combinations_helper(k, lst, cur) do
    lst
    |> Enum.with_index(1)
    |> Enum.map(fn {elem, index} ->
      new_cur = cur ++ [elem]

      if length(new_cur) == k do
        new_cur
      else
        new_lst = Enum.drop(lst, index)
        combinations_helper(k, new_lst, new_cur)
      end
    end)
  end

  defp our_reduce(lst, dst \\ []) do
    Enum.reduce(lst, dst, fn x, acc ->
      if is_list(x) && !Enum.empty?(x) do
        if Enum.all?(x, &(!is_list(&1))) do
          [x | acc]
        else
          our_reduce(x, acc)
        end
      else
        if !is_list(x), do: [x | acc], else: acc
      end
    end)
  end
end
