defmodule Challenge20 do
  @moduledoc """
  (*) Remove the K'th element from a list.
  """
  def remove_at(lst, k) do
    lst
    |> Stream.with_index(1)
    |> Enum.reduce([], fn {val, index}, acc ->
      if index == k, do: acc, else: [val | acc]
    end)
    |> Enum.reverse()
  end
end
