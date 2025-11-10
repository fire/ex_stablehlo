defmodule Challenge24Test do
  use ExUnit.Case

  test "rnd_select" do
    k = 6
    items_cnt = 49

    result = Challenge24.rnd_select(k, items_cnt)
    assert Helpers.check_two_enumerables_equal?(result, Enum.to_list(1..items_cnt))
  end
end
