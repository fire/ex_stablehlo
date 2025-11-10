defmodule Challenge18Test do
  use ExUnit.Case

  test "slice" do
    assert Challenge18.slice(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3, 7) == [
             "c",
             "d",
             "e",
             "f",
             "g"
           ]
  end
end
