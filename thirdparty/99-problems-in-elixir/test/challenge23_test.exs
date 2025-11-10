defmodule Challenge23Test do
  use ExUnit.Case

  setup_all do
    {:ok, test_list: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}
  end

  test "rnd_select", state do
    desired_size = state[:test_list] |> length |> div(2)

    result = Challenge23.rnd_select(state[:test_list], desired_size)
    assert Helpers.check_two_enumerables_equal?(result, state[:test_list])
  end
end
