defmodule Challenge90Test do
  use ExUnit.Case

  test "solve" do
    assert Challenge90.solve() |> length() == 92
  end
end
