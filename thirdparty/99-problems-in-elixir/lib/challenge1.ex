defmodule Challenge1 do
  @moduledoc """
    (*) Find the last element of a list.
  """
  def p01_my_last(lst), do: List.last(lst)

  def p01_my_last_02([head]), do: head

  def p01_my_last_02([_head | tail]), do: p01_my_last_02(tail)

  def p01_my_last_02(_), do: nil
end
