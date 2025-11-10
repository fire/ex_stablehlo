defmodule Challenge35Test do
  use ExUnit.Case

  test "prime_factors" do
    assert Challenge35.prime_factors(315) == [3, 3, 5, 7]
    assert Challenge35.prime_factors(42) == [2, 3, 7]
  end
end
