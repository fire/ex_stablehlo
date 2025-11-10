defmodule Challenge25Test do
  use ExUnit.Case

  test "rnd_permu" do
    lst = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    result = Challenge25.rnd_permu(lst)

    assert Helpers.check_two_enumerables_equal?(result, lst)
  end
end
