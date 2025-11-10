defmodule Challenge60Test do
  use ExUnit.Case
  doctest Challenge1

  test "min_nodes" do
    assert Challenge60.min_nodes(0) == 0
    assert Challenge60.min_nodes(1) == 1
    assert Challenge60.min_nodes(2) == 2
    assert Challenge60.min_nodes(3) == 4
    assert Challenge60.min_nodes(10) == 143
  end

  test "max_height" do
    assert Challenge60.max_height(0) == 0
    assert Challenge60.max_height(1) == 1
    assert Challenge60.max_height(2) == 2
    assert Challenge60.max_height(4) == 3
    assert Challenge60.max_height(5) == 3
    assert Challenge60.max_height(10) == 4
  end

  test "hbal_tree_nodes" do
    assert Challenge60.hbal_tree_nodes(1) |> length == 1
    assert Challenge60.hbal_tree_nodes(2) |> length == 2
    assert Challenge60.hbal_tree_nodes(3) |> length == 1
    assert Challenge60.hbal_tree_nodes(4) |> length == 4
    assert Challenge60.hbal_tree_nodes(5) |> length == 6
    assert Challenge60.hbal_tree_nodes(6) |> length == 4
    assert Challenge60.hbal_tree_nodes(7) |> length == 17
    assert Challenge60.hbal_tree_nodes(8) |> length == 32
    assert Challenge60.hbal_tree_nodes(9) |> length == 44
    assert Challenge60.hbal_tree_nodes(10) |> length == 60
    assert Challenge60.hbal_tree_nodes(11) |> length == 70
    assert Challenge60.hbal_tree_nodes(12) |> length == 184
    assert Challenge60.hbal_tree_nodes(13) |> length == 476
    assert Challenge60.hbal_tree_nodes(15) |> length == 1553
  end
end
