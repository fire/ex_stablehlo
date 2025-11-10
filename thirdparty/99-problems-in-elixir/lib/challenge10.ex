defmodule Challenge10 do
  @moduledoc """
  (*) Run-length encoding of a list.
    Use the result of problem P09 to implement the so-called run-length encoding data compression method.
    Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.
  """
  def encode(lst) do
    lst
    |> Challenge9.pack()
    |> Enum.map(fn item ->
      {length(item), hd(item)}
    end)
  end
end
