defmodule Challenge91Test do
  use ExUnit.Case

  test "solve" do
    result = Challenge91.solve()
    assert length(result) == 64
    assert length(Enum.uniq(result)) == length(result)

    pairs = Enum.zip(result, tl(result))

    checks_passed_count =
      Enum.count(pairs, fn pair ->
        {solution_coord, next_solution_coord} = pair
        next_solution_coord in Challenge91.jumps(solution_coord)
      end)

    assert checks_passed_count == length(result) - 1
  end
end
