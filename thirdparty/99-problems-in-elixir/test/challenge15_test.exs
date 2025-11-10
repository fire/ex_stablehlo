defmodule Challenge15Test do
  use ExUnit.Case

  test "dupli" do
    assert Challenge15.dupli(["a", "b", "c"], 3) == ["a", "a", "a", "b", "b", "b", "c", "c", "c"]
    assert Challenge15.dupli([], 1) == []
  end
end
