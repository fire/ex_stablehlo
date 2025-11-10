defmodule Challenge27Test do
  use ExUnit.Case

  setup_all do
    {:ok, people: [:a, :b, :c, :d, :e, :f, :g, :h, :i]}
  end

  test "group3", state do
    assert length(Challenge27.group3(state[:people])) == 1260
  end

  test "group", state do
    assert length(Challenge27.group(state[:people], [2, 3, 4])) == 1260
  end
end
