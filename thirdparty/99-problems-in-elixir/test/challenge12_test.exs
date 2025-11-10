defmodule Challenge12Test do
  use ExUnit.Case

  test "decode" do
    assert Challenge12.decode([{4, "a"}, "b", {2, "c"}, {2, "a"}, "d", {4, "e"}]) == [
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
           ]
  end

  test "decode_my1" do
    assert Challenge12.decode_my1([{4, "a"}, "b", {2, "c"}, {2, "a"}, "d", {4, "e"}]) == [
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
           ]
  end

  test "decode_my2" do
    assert Challenge12.decode_my2([{4, "a"}, "b", {2, "c"}, {2, "a"}, "d", {4, "e"}]) == [
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
           ]
  end
end
