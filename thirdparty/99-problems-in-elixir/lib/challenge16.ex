defmodule Challenge16 do
  @moduledoc """
  (**) Drop every N'th element from a list.
  """
  def drop(lst, n) do
    lst
    |> Enum.with_index(1)
    |> Enum.reduce([], fn {val, index}, acc ->
      if rem(index, n) == 0 do
        # drop val every n'th time
        acc
      else
        [val | acc]
      end
    end)
    |> Enum.reverse()
  end

  def drop_another_version(lst, n) do
    lst
    |> Enum.with_index(1)
    |> Enum.filter(fn {_val, index} -> rem(index, n) != 0 end)
    |> Enum.map(&Kernel.elem(&1, 0))
  end

  @doc """
  (**) Drop every N'th element from a list.
  """
  def drop_using_recursion(lst, n) do
    drop_using_recursion_helper(lst, [], n, 0)
  end

  defp drop_using_recursion_helper([], dst, _n, _cur_index) do
    dst |> Enum.reverse()
  end

  defp drop_using_recursion_helper([head | tail], dst, n, cur_index) do
    dst =
      if rem(cur_index + 1, n) == 0 do
        dst
      else
        # drop val every n'th time
        [head | dst]
      end

    drop_using_recursion_helper(tail, dst, n, cur_index + 1)
  end
end
