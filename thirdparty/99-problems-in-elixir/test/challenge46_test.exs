defmodule Challenge46Test do
  use ExUnit.Case

  test "table" do
    assert Challenge46.table(fn a, b -> Challenge46.tbl_and(a, Challenge46.tbl_or(a, b)) end) ==
             ["true true true", "true false true", "false true false", "false false false"]

    assert Challenge46.table(fn a, b -> Challenge46.tbl_or(a, b) end) ==
             ["true true true", "true false true", "false true true", "false false false"]
  end
end
