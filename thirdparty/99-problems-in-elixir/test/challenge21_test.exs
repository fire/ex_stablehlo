defmodule Challenge21Test do
  use ExUnit.Case

  test "insert_at" do
    assert Challenge21.insert_at("alfa", ["a", "b", "c", "d"], 2) == ["a", "alfa", "b", "c", "d"]
  end
end
