defmodule Challenge21 do
  @moduledoc """
  (*) Insert an element at a given position into a list.
  """
  def insert_at(_item, lst, k) when k < 1 or k > length(lst), do: nil

  def insert_at(item, lst, k) do
    {l1, l2} = Enum.split(lst, k - 1)
    Enum.concat([l1, [item], l2])
  end
end
