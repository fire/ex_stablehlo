defmodule Challenge25 do
  @moduledoc """
  (*) Generate a random permutation of the elements of a list.
  """
  def rnd_permu(lst) do
    tmp_list = Challenge24.rnd_select(length(lst), length(lst))

    Enum.map(tmp_list, &Enum.at(lst, &1 - 1))
  end
end
