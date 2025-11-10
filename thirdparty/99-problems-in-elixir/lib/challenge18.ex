defmodule Challenge18 do
  @moduledoc """
  (**) Extract a slice from a list.
  Given two indices, i and k, the slice is the list containing the elements
  between the i'th and k'th element of the original list (both limits included).
  Start counting the elements with 1.
  """
  def slice(lst, i, k) do
    lst
    |> Stream.with_index(1)
    |> Enum.reduce([], fn {val, index}, acc ->
      cond do
        index < i -> acc
        index <= k -> [val | acc]
        true -> acc
      end
    end)
    |> Enum.reverse()
  end
end
