defmodule Challenge33Test do
  use ExUnit.Case

  test "coprime" do
    assert Challenge33.coprime(35, 64)
    assert !Challenge33.coprime(36, 64)
  end
end
