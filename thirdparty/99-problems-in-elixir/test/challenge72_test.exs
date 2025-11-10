defmodule Challenge72Test do
  use ExUnit.Case

  test "bottom_up" do
    assert Challenge72.bottom_up(["a", ["f", "g"], "c", ["b", "d", "e"]]) == ["g", "f", "c", "d", "e", "b", "a"]
    assert Challenge72.bottom_up(["a", "b"]) == ["b", "a"]
    assert Challenge72.bottom_up(["a", ["b", "c"]]) == ["c", "b", "a"]
    assert Challenge72.bottom_up(["b", "d", "e"]) == ["d", "e", "b"]
    assert Challenge72.bottom_up("a") == ["a"]
    assert Challenge72.bottom_up([]) == []
  end
end
