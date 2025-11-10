defmodule Challenge90SecondSolutionTest do
  use ExUnit.Case

  test "solve" do
    assert Challenge90SecondSolution.solve() |> length() == 92
  end
end
