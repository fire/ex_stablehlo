defmodule Challenge50Test do
  use ExUnit.Case

  test "huffman" do
    assert Enum.sort(
             Challenge50.huffman([{"a", 5}, {"b", 9}, {"c", 12}, {"d", 13}, {"e", 16}, {"f", 45}])
           ) ==
             Enum.sort([
               {"f", "0"},
               {"c", "100"},
               {"d", "101"},
               {"a", "1100"},
               {"b", "1101"},
               {"e", "111"}
             ])

    assert Enum.sort(
             Challenge50.huffman([{"a", 45}, {"b", 13}, {"c", 12}, {"d", 16}, {"e", 9}, {"f", 5}])
           ) ==
             Enum.sort([
               {"a", "0"},
               {"b", "101"},
               {"c", "100"},
               {"d", "111"},
               {"e", "1101"},
               {"f", "1100"}
             ])
  end
end
