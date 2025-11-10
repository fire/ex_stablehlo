defmodule Challenge19Test do
  use ExUnit.Case

  setup_all do
    {:ok, test_list: ["a", "b", "c", "d", "e", "f", "g", "h"]}
  end

  test "rotate", state do
    assert Challenge19.rotate(state[:test_list], 3) == ["d", "e", "f", "g", "h", "a", "b", "c"]
    assert Challenge19.rotate(state[:test_list], -2) == ["g", "h", "a", "b", "c", "d", "e", "f"]
  end
end
