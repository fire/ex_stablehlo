defmodule Challenge5Test do
  use ExUnit.Case
  doctest Challenge5

  test "p05_reverse" do
    assert Challenge5.reverse([]) == []
    assert Challenge5.reverse([1, 2, 3]) == [3, 2, 1]
    assert Challenge5.reverse([1, 2]) == [2, 1]
    assert Challenge5.reverse([1]) == [1]
  end

  test "p05_reverse_my" do
    assert Challenge5.reverse_my([]) == []
    assert Challenge5.reverse_my([1, 2, 3]) == [3, 2, 1]
    assert Challenge5.reverse_my([1, 2]) == [2, 1]
    assert Challenge5.reverse([1]) == [1]
  end
end
