defmodule Challenge48Test do
  use ExUnit.Case
  # importing "custom" operators
  import Challenge47

  test "table_n" do
    result = Challenge48.table_n(fn a, b, c -> a &&& b &&& c end)

    result_expected = [
      "false false false false",
      "false false true false",
      "false true false false",
      "false true true false",
      "true false false false",
      "true false true false",
      "true true false false",
      "true true true true"
    ]

    assert Helpers.check_two_enumerables_equal?(result, result_expected)
  end
end
