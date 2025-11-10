defmodule Challenge11Test do
  use ExUnit.Case

  test "encode_modified" do
    assert Challenge11.encode_modified([
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
