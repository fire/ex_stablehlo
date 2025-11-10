defmodule Challenge23 do
  @moduledoc """
  (*) Extract a given number of randomly selected elements from a list.
  """
  def rnd_select(_lst, k) when k < 0, do: []
  def rnd_select(lst, k), do: Enum.take_random(lst, k)
end
