defmodule Challenge10Test do
  use ExUnit.Case

  test "encode" do
    assert Challenge10.encode([
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
           ]) == [{4, "a"}, {1, "b"}, {2, "c"}, {2, "a"}, {1, "d"}, {4, "e"}]

    assert Challenge10.encode([]) == []
    assert Challenge10.encode(["a"]) == [{1, "a"}]
  end
end
