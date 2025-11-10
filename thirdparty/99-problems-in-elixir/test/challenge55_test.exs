defmodule Challenge55Test do
  use ExUnit.Case

  setup_all do
    {:ok,
     cbal_tree_1_result_list: [
       %TreeNode{symbol: :x, left: nil, right: nil}
     ],
     cbal_tree_2_result_list: [
       %TreeNode{symbol: :x, left: %TreeNode{symbol: :x, left: nil, right: nil}, right: nil},
       %TreeNode{symbol: :x, left: nil, right: %TreeNode{symbol: :x, left: nil, right: nil}}
     ],
     cbal_tree_3_result_list: [
       %TreeNode{
         symbol: :x,
         left: %TreeNode{symbol: :x, left: nil, right: nil},
         right: %TreeNode{symbol: :x, left: nil, right: nil}
       }
     ]}
  end

  test "cbal_tree_0" do
    assert Challenge55.cbal_tree(0) == [nil]
  end

  test "cbal_tree_1", state do
    result_1 = Challenge55.cbal_tree(1)
    desired_result_1 = state[:cbal_tree_1_result_list]

    assert Helpers.check_two_enumerables_equal?(result_1, desired_result_1)
  end

  test "cbal_tree_2", state do
    result_2 = Challenge55.cbal_tree(2)
    desired_result_2 = state[:cbal_tree_2_result_list]

    assert Helpers.check_two_enumerables_equal?(result_2, desired_result_2)
  end

  test "cbal_tree_3", state do
    result_3 = Challenge55.cbal_tree(3)
    desired_result_3 = state[:cbal_tree_3_result_list]

    assert Helpers.check_two_enumerables_equal?(result_3, desired_result_3)
  end

  test "cbal_tree_6" do
    assert Challenge55.cbal_tree(6) |> length == 4
    assert Challenge55.cbal_tree(7) |> length == 1
    assert Challenge55.cbal_tree(9) |> length == 16
    assert Challenge55.cbal_tree(11) |> length == 16
    assert Challenge55.cbal_tree(25) |> length == 1024
  end
end
