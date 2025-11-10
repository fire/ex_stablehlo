defmodule Challenge3Test do
  use ExUnit.Case
  doctest Challenge3

  test "p03_find_k_item" do
    assert Challenge3.p03_find_k_item([], 0) == nil
    assert Challenge3.p03_find_k_item([], -1) == nil
    assert Challenge3.p03_find_k_item([], 1) == nil

    assert Challenge3.p03_find_k_item(["a", "b"], 1) == "a"
    assert Challenge3.p03_find_k_item(["a", "b"], 2) == "b"
    assert Challenge3.p03_find_k_item(["a", "b"], -1) == nil
    assert Challenge3.p03_find_k_item(["a", "b"], 3) == nil
  end

  test "p03_find_k_item_my" do
    assert Challenge3.p03_find_k_item_my([], 0) == nil
    assert Challenge3.p03_find_k_item_my([], -1) == nil
    assert Challenge3.p03_find_k_item_my([], 1) == nil

    assert Challenge3.p03_find_k_item_my(["a", "b"], 1) == "a"
    assert Challenge3.p03_find_k_item_my(["a", "b"], 2) == "b"
    assert Challenge3.p03_find_k_item_my(["a", "b"], -1) == nil
    assert Challenge3.p03_find_k_item_my(["a", "b"], 3) == nil
  end
end
