defmodule Challenge26Test do
  use ExUnit.Case

  test "combinations_first_test" do
    lst = ["a", "b", "c", "d", "e", "f"]

    correct_result = [
      ["a", "b", "c"],
      ["a", "b", "d"],
      ["a", "b", "e"],
      ["a", "b", "f"],
      ["a", "c", "d"],
      ["a", "c", "e"],
      ["a", "c", "f"],
      ["a", "d", "e"],
      ["a", "d", "f"],
      ["a", "e", "f"],
      ["b", "c", "d"],
      ["b", "c", "e"],
      ["b", "c", "f"],
      ["b", "d", "e"],
      ["b", "d", "f"],
      ["b", "e", "f"],
      ["c", "d", "e"],
      ["c", "d", "f"],
      ["c", "e", "f"],
      ["d", "e", "f"]
    ]

    correct_result_sorted = Enum.sort(correct_result)

    result_a = Challenge26.combinations(3, lst)
    result_b = Challenge26SecondSolution.combinations(3, lst)
    result_c = Challenge26ThirdSolution.combinations(3, lst)

    assert Enum.sort(result_a) == correct_result_sorted
    assert Enum.sort(result_b) == correct_result_sorted
    assert Enum.sort(result_c) == correct_result_sorted
  end

  test "combinations_second_test" do
    lst = Enum.to_list(1..12)

    assert length(Challenge26.combinations(3, lst)) == 220
    assert length(Challenge26SecondSolution.combinations(3, lst)) == 220
    assert length(Challenge26ThirdSolution.combinations(3, lst)) == 220
  end
end
