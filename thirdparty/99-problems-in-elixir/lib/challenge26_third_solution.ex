defmodule Challenge26ThirdSolution do
  @moduledoc """
  (**) Generate combinations of K distinct objects chosen from the N elements of a list.
  """

  defp combinations_impl(k, seq, cur_count \\ 0, cur_acc \\ [], result \\ [])
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
        Enum.concat(tails_combinations(k, h, tail), combinations(k, tail))
    end
  end

  defp tails_combinations(k, header, seq, acc \\ [])
  defp tails_combinations(_, _, [], acc), do: acc |> Enum.concat()

  defp tails_combinations(k, header, seq, acc) do
    tails_combinations(
      k,
      header,
      tl(seq),
      [combinations_impl(k, [header | seq]) | acc]
    )
  end
end
