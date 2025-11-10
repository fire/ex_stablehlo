defmodule Challenge32Test do
  use ExUnit.Case

  test "gcd" do
    assert Challenge32.gcd(123, 36) == 3
    assert Challenge32.gcd(1180, 482) == 2
    assert Challenge32.gcd(35, 50) == 5
    assert Challenge32.gcd(16, 60) == 4
    assert Challenge32.gcd(150, 180) == 30

    assert_raise RuntimeError, fn ->
      Challenge32.gcd(-50, 18)
    end

    assert_raise RuntimeError, fn ->
      Challenge32.gcd(50, -18)
    end

    assert_raise RuntimeError, fn ->
      Challenge32.gcd(-50, -18)
    end
  end
end
