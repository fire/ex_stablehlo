defmodule Challenge20Test do
  use ExUnit.Case

  test "remove_at" do
    assert Challenge20.remove_at(["a", "b", "c", "d"], 2) == ["a", "c", "d"]
  end
end
