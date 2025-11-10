defmodule Challenge71Test do
  use ExUnit.Case

  test "ipl" do
    assert Challenge71.ipl([:a, [:b, [:c, :d], :e], [:f, [:g, :h, :i]]]) == 17
    assert Challenge71.ipl(["a", ["f", "g"], "c", ["b", "d", "e"]]) == 9
    assert Challenge71.ipl("a") == 0
    assert Challenge71.ipl([:a, :b]) == 1
    assert Challenge71.ipl([:a, [:b, :c]]) == 3
    assert Challenge71.ipl([:a, [:b, :c], :d]) == 4
  end
end
