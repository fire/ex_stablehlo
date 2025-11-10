defmodule Challenge5 do
  @moduledoc """
    (*) Reverse a list.
  """
  def reverse(lst), do: Enum.reverse(lst)

  def reverse_my(lst), do: helper(lst, [])

  defp helper([], dst), do: dst

  defp helper([h | tail], dst), do: helper(tail, [h | dst])
end
