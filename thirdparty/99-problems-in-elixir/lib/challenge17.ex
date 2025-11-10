defmodule Challenge17 do
  @moduledoc """
  (*) Split a list into two parts; the length of the first part is given.
    Do not use any predefined predicates.
  """
  def split(_lst, n) when n <= 0, do: nil
  def split(lst, n) when n >= length(lst), do: [lst, []]
  def split(lst, n), do: split_helper(lst, %ListsPair{}, n, 0)

  defp split_helper([], %ListsPair{first: first, second: second}, _n, _counter) do
    [first, second] |> Enum.map(&Enum.reverse/1)
  end

  defp split_helper([head | tail], dst = %ListsPair{first: first, second: second}, n, counter) do
    dst =
      cond do
        counter == 0 -> %{dst | first: [head]}
        counter <= n - 1 -> %{dst | first: [head | first], second: []}
        true -> %{dst | second: [head | second]}
      end

    split_helper(tail, dst, n, counter + 1)
  end
end
