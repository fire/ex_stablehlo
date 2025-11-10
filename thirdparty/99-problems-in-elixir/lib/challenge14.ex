defmodule Challenge14 do
  @moduledoc """
  (*) Duplicate the elements of a list.
  """
  def dupli(lst) do
    lst
    |> Enum.map(&[&1, &1])
    |> List.flatten()
  end
end
