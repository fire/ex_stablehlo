defmodule Challenge24 do
  @moduledoc """
  (*) Lotto: Draw N different random numbers from the set 1..M.
  """
  def rnd_select(n, m), do: 1..m |> Enum.take_random(n)
end
