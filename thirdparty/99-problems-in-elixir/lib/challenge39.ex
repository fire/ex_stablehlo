defmodule Challenge39 do
  @moduledoc """
  (*) A list of prime numbers.
    Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.
  """
  def prime_numbers_list(from, to) do
    Enum.filter(
      from..to,
      &Challenge31.is_prime/1
    )
  end
end
