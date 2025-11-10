defmodule Challenge40 do
  @moduledoc """
  (**) Goldbach's conjecture.
    Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers.
    Example: 28 = 5 + 23.
    It is one of the most famous facts in number theory that has not been proved to be correct in the general case.
    It has been numerically confirmed up to very large numbers.
    Write a predicate to find the two prime numbers that sum up to a given even integer.
  """
  def goldbach(num) when num > 2 and rem(num, 2) == 0 do
    result_with_duplicates_in_another_order =
      1..(num - 1)
      |> Enum.filter(fn elem ->
        Challenge31.is_prime(elem) && Challenge31.is_prime(num - elem)
      end)
      |> Enum.map(fn elem -> {elem, num - elem} end)

    Enum.reduce(result_with_duplicates_in_another_order, [], fn elem = {a, b}, acc ->
      if {b, a} in acc, do: acc, else: [elem | acc]
    end)
  end

  def goldbach(_num), do: nil
end
