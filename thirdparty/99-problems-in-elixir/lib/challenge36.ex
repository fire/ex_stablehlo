defmodule Challenge36 do
  @moduledoc """
  (**) Determine the prime factors of a given positive integer.
    Construct a list containing the prime factors and their multiplicity.
  """
  def prime_factors_mult(t) do
    t
    |> Challenge35.prime_factors()
    |> Challenge13.encode_direct()
    |> Enum.map(fn elem ->
      case elem do
        {count, letter} -> {letter, count}
        letter -> {letter, 1}
      end
    end)
  end
end
