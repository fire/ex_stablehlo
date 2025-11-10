defmodule Challenge41Test do
  use ExUnit.Case

  test "goldbach_list" do
    # notice, current implementation returns all possible solutions,
    # not only the "first ones" stated in the task
    result = Challenge41.goldbach_list(9, 20)

    result_expected_items = [
      "10 = 3 + 7",
      "12 = 5 + 7",
      "14 = 3 + 11",
      "16 = 3 + 13",
      "18 = 5 + 13",
      "20 = 3 + 17"
    ]

    assert Enum.all?(result_expected_items, fn item -> item in result end)
  end

  test "goldbach_list_limit" do
    # notice, current implementation returns all possible solutions,
    # not only the "first ones" stated in the task

    result = Challenge41.goldbach_list_for_limit(1, 2000, 50)

    result_expected_items = [
      "992 = 73 + 919",
      "1382 = 61 + 1321",
      "1856 = 67 + 1789",
      "1928 = 61 + 1867"
    ]

    assert Enum.all?(result_expected_items, fn item -> item in result end)
  end
end
