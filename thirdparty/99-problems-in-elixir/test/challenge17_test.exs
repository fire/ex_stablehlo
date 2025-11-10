defmodule Challenge17Test do
  use ExUnit.Case

  setup_all do
    {:ok, test_list: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"]}
  end

  test "split", state do
    assert Challenge17.split(state[:test_list], 3) == [
             ["a", "b", "c"],
             ["d", "e", "f", "g", "h", "i", "k"]
           ]

    assert Challenge17.split(state[:test_list], 0) == nil
    assert Challenge17.split(state[:test_list], -1) == nil

    assert Challenge17.split(state[:test_list], length(state[:test_list])) == [
             ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"],
             []
           ]

    assert Challenge17.split(state[:test_list], length(state[:test_list]) + 1) == [
             ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"],
             []
           ]
  end
end
