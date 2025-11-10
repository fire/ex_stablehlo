defmodule Challenge49Test do
  use ExUnit.Case

  test "gray" do
    assert Challenge49.gray(1) == ["0", "1"]
    assert Challenge49.gray(2) == ["00", "01", "11", "10"]

    assert Challenge49.gray(3) == [
             "000",
             "001",
             "011",
             "010",
             "110",
             "111",
             "101",
             "100"
           ]

    assert Challenge49.gray(4) == [
             "0000",
             "0001",
             "0011",
             "0010",
             "0110",
             "0111",
             "0101",
             "0100",
             "1100",
             "1101",
             "1111",
             "1110",
             "1010",
             "1011",
             "1001",
             "1000"
           ]
  end
end
