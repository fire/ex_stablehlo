defmodule Challenge15 do
  @moduledoc """
  (**) Duplicate the elements of a list a given number of times.
  """
  def dupli(lst, num) do
    lst
    |> Enum.map(&List.duplicate(&1, num))
    |> List.flatten()
  end
end
