defmodule Challenge9Test do
  use ExUnit.Case

  test "pack" do
    assert Challenge9.pack(["a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e"]) ==
             [["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"]]

    assert Challenge9.pack([]) == []
    assert Challenge9.pack(["a"]) == [["a"]]
  end
end
