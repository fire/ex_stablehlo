defmodule Challenge4 do
  @moduledoc """
    (*) Find the number of elements of a list.
  """
  def p04_find_len(lst), do: length(lst)

  def p04_find_len_my(lst), do: helper(lst, 0)

  defp helper([_h | t], acc), do: helper(t, acc + 1)

  defp helper([], acc), do: acc
end
