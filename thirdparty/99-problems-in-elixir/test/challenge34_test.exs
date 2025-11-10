defmodule Challenge34Test do
  use ExUnit.Case

  test "totient_phi" do
    assert Challenge34.totient_phi(1) == 1
    assert Challenge34.totient_phi(10) == 4
    assert Challenge34.totient_phi(7919) == 7918
  end
end
