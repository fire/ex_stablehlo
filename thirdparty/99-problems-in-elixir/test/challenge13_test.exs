defmodule Challenge13Test do
  use ExUnit.Case

  test "encode_direct" do
    assert Challenge13.encode_direct([
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
           ]) == [{4, "a"}, "b", {2, "c"}, {2, "a"}, "d", {4, "e"}]
  end
end
