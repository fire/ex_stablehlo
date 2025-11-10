defmodule Challenge22 do
  @moduledoc """
  (*) Create a list containing all integers within a given range.
  """
  def range(x, y) when x >= y, do: []

  def range(x, y), do: range_helper(x, y, []) |> Enum.reverse()

  defp range_helper(x, y, dst) when x > y, do: dst
  defp range_helper(x, y, dst), do: range_helper(x + 1, y, [x | dst])
end
