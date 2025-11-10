defmodule Challenge8Test do
  use ExUnit.Case

  test "compress" do
    assert Challenge8.compress([
             "a",
             "a",
             "a",
             "a",
             "b",
             "c",
             "c",
             "a",
             "a",
             "d",
             "e",
             "e",
             "e",
             "e"
           ]) == ["a", "b", "c", "a", "d", "e"]

    assert Challenge8.compress([]) == []
    assert Challenge8.compress(["a"]) == ["a"]
  end
end
