defmodule Challenge4Test do
  use ExUnit.Case
  doctest Challenge4

  test "p04_find_len" do
    assert Challenge4.p04_find_len([]) == 0
    assert Challenge4.p04_find_len([1]) == 1
    assert Challenge4.p04_find_len([1, 2]) == 2
  end

  test "p03_find_len_my" do
    assert Challenge4.p04_find_len_my([]) == 0
    assert Challenge4.p04_find_len_my([1]) == 1
    assert Challenge4.p04_find_len_my([1, 2]) == 2
  end
end
