defmodule Challenge40Test do
  use ExUnit.Case

  test "goldbach" do
    assert is_nil(Challenge40.goldbach(3))
    assert {5, 23} in Challenge40.goldbach(28)
    assert {61, 1867} in Challenge40.goldbach(1928)
  end
end
