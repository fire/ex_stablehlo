defmodule Challenge19 do
  @moduledoc """
  (**) Rotate a list N places to the left.
  """
  def rotate(lst, k) do
    lst
    |> Stream.with_index()
    |> Enum.reduce([], fn {_val, index}, acc ->
      new_index = if index + k <= length(lst) - 1, do: index + k, else: index + k - length(lst)
      [Enum.at(lst, new_index) | acc]
    end)
    |> Enum.reverse()
  end
end
