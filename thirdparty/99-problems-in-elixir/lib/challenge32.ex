defmodule Challenge32 do
  @moduledoc """
  (**) Determine the greatest common divisor of two positive integer numbers.
    Use Euclid's algorithm.
  """
  def gcd(a, b) when a > 0 and b > 0 do
    {a, b} = if a > b, do: {a, b}, else: {b, a}
    gcd_impl(a, b)
  end

  def gcd(_a, _b) do
    raise("a and b should be positive integers")
  end

  defp gcd_impl(a, b) do
    remainder = rem(a, b)
    if remainder == 0, do: b, else: gcd_impl(b, remainder)
  end
end
