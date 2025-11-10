defmodule Challenge7 do
  @moduledoc """
  (**) Flatten a nested list structure.
  """
  def flatten(lst), do: List.flatten(lst)

  def my_flatten(lst) do
    Enum.reduce(lst, [], fn item, acc ->
      if is_list(item), do: acc ++ my_flatten(item), else: acc ++ [item]
    end)
  end

  def my_flatten_better_version(lst) do
    lst |> my_flatten_better_version_traverse([]) |> Enum.reverse()
  end

  defp my_flatten_better_version_traverse([], dst) do
    dst
  end

  defp my_flatten_better_version_traverse([h | t], dst) do
    if is_list(h) do
      traversed_head_lst = my_flatten_better_version_traverse(h, [])
      my_flatten_better_version_traverse(t, Enum.concat(traversed_head_lst, dst))
    else
      my_flatten_better_version_traverse(t, [h | dst])
    end
  end
end
