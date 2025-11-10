defmodule Challenge26SecondSolution do
  @moduledoc """
  (**) Generate combinations of K distinct objects chosen from the N elements of a list.
  """

  defp combinations_impl(k, lst, cur_count \\ 0, cur_acc \\ [], result \\ [])
  defp combinations_impl(_, [], _, _, result), do: result

  defp combinations_impl(k, [h | t], cur_count, cur_acc, result) do
    {new_count, new_acc, new_result} =
      if cur_count + 1 < k do
        {cur_count + 1, cur_acc ++ [h], result}
      else
        {cur_count, cur_acc, result ++ [cur_acc ++ [h]]}
      end

    combinations_impl(k, t, new_count, new_acc, new_result)
  end

  def combinations(k, lst) when k <= 0 or k > length(lst), do: []
  def combinations(_k, []), do: []

  def combinations(k, lst = [h | tail]) do
    default_acc = combinations_impl(k, lst)

    cond do
      k == 1 ->
        default_acc

      k == 2 ->
        Enum.concat(default_acc, combinations(k, tail))

      true ->
        result =
          Enum.reduce(1..length(tail), default_acc, fn x, acc ->
            Enum.concat(acc, combinations_impl(k, [h | Enum.drop(tail, x)]))
          end)

        Enum.concat(result, combinations(k, tail))
    end
  end
end
