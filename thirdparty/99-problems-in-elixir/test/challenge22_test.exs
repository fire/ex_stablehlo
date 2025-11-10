defmodule Challenge22Test do
  use ExUnit.Case

  test "range" do
    assert Challenge22.range(4, 9) == Enum.to_list(4..9)
  end
end
