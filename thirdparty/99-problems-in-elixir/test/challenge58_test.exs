defmodule Challenge58Test do
  use ExUnit.Case

  test "sym_cbal_trees" do
    assert Challenge58.sym_cbal_trees(1) == [%TreeNode{symbol: :x, left: nil, right: nil}]
    assert Challenge58.sym_cbal_trees(3) |> length == 1
    # slow
    assert Challenge58.sym_cbal_trees(37) |> length == 256
    # assert Challenge58.sym_cbal_trees(57) |> length == 256
  end
end
