defmodule Challenge14Test do
  use ExUnit.Case

  test "dupli" do
    assert Challenge14.dupli(["a", "b", "c", "c", "d"]) == [
             "a",
             "a",
             "b",
             "b",
             "c",
             "c",
             "c",
             "c",
             "d",
             "d"
           ]

    assert Challenge14.dupli([]) == []
  end
end
