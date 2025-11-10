defmodule Challenge35 do
  @moduledoc """
  (**) Determine the prime factors of a given positive integer.
  """
  def prime_factors(t) do
    t |> prime_factors_impl() |> Enum.reverse()
  end

  defp find_next_prime_number(i) do
    if Challenge31.is_prime(i), do: i, else: find_next_prime_number(i + 1)
  end

  defp prime_factors_impl(t, i \\ 1, result \\ []) do
    if t == 1 do
      result
    else
      next_prime_number = find_next_prime_number(i + 1)

      case rem(t, next_prime_number) == 0 do
        true ->
          prime_factors_impl(div(t, next_prime_number), 1, [next_prime_number | result])

        false ->
          prime_factors_impl(t, next_prime_number, result)
      end
    end
  end
end
