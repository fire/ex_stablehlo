defmodule Challenge37Test do
  use ExUnit.Case

  test "totient_phi_improved" do
    assert Challenge37.totient_phi_improved(10) == 4
    assert Challenge37.totient_phi_improved(7919) == 7918
  end
end
