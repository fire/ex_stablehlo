defmodule Challenge36Test do
  use ExUnit.Case

  test "prime_factors_mult" do
    assert Challenge36.prime_factors_mult(315) == [{3, 2}, {5, 1}, {7, 1}]
  end
end
