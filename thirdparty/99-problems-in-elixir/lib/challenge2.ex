defmodule Challenge2 do
  @moduledoc """
    (*) Find the last but one element of a list.
  """
  def p02_but_last(lst) do
    len = length(lst)

    if len < 2 do
      raise("Length must be greater than one")
    end

    Enum.at(lst, len - 2)
  end

  @doc """
    (*) Find the last but one element of a list.
  """
  def p02_but_last_1(lst) do
    len = length(lst)

    if len < 2 do
      raise("Length must be greater than one")
    end

    p02_but_last_1_helper(hd(lst), tl(lst))
  end

  defp p02_but_last_1_helper(acc, [_head]), do: acc

  defp p02_but_last_1_helper(_acc, [head | tail]), do: p02_but_last_1_helper(head, tail)

  @doc """
    (*) Find the last but one element of a list.
  """
  def p02_but_last_2([a, _b]), do: a

  def p02_but_last_2([_a, b | tail]), do: p02_but_last_2([b | tail])

  def p02_but_last_2(_) do
    raise("Length must be greater than one")
  end
end
