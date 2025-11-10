defmodule Challenge1Test do
  use ExUnit.Case
  doctest Challenge1

  test "p01_my_last" do
    assert Challenge1.p01_my_last([]) == nil
    assert Challenge1.p01_my_last([1]) == 1
    assert Challenge1.p01_my_last([1, 2]) == 2
  end

  test "p01_my_last_02" do
    assert Challenge1.p01_my_last_02([]) == nil
    assert Challenge1.p01_my_last_02([1]) == 1
    assert Challenge1.p01_my_last_02([1, 2]) == 2
  end
end
