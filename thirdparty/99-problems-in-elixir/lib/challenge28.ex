defmodule Challenge28 do
  @moduledoc """
  a) (**) Sorting a list of lists according to length of sublists
  a) We suppose that a list contains elements that are lists themselves.
  The objective is to sort the elements of this list according to their length.
  E.g. short lists first, longer lists later, or vice versa.
  """

  def lsort(lst_of_lsts) do
    List.foldl(lst_of_lsts, [], fn src_elem, acc ->
      src_elem_len = length(src_elem)
      pos = Enum.count(acc, &(src_elem_len >= length(&1)))
      acc = List.insert_at(acc, pos, src_elem)
      acc
    end)
  end

  def lsort_another_version(lst_of_lists) do
    Enum.sort(lst_of_lists, &(length(&1) <= length(&2)))
  end

  @doc """
  b) (**) Again, we suppose that a list contains elements that are lists themselves.
  But this time the objective is to sort the elements of this list according to their length frequency;
  i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first,
  others with a more frequent length come later.
  """
  def lfsort(lst_of_lists) do
    freqs = lst_of_lists |> Enum.frequencies_by(&length/1)
    Enum.sort(lst_of_lists, &(freqs[length(&1)] <= freqs[length(&2)]))
  end
end
