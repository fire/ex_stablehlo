defmodule Challenge39Test do
  use ExUnit.Case

  test "prime_numbers_list" do
    assert Challenge39.prime_numbers_list(1, 10) == [2, 3, 5, 7]
  end
end
