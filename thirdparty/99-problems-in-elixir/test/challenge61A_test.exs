defmodule Challenge61ATest do
  use ExUnit.Case

  setup_all do
    {:ok,
     leaves_result_list: [
       %TreeNode{left: nil, right: nil, symbol: 2},
       %TreeNode{symbol: 3, left: nil, right: nil}
     ]}
  end

  test "leaves", state do
    assert Challenge61A.leaves(nil) == []

    assert Challenge61A.leaves(%TreeNode{symbol: 1, left: nil, right: nil}) == [
             %TreeNode{symbol: 1, left: nil, right: nil}
           ]

    assert Challenge61A.leaves(%TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: nil
           }) == [%TreeNode{left: nil, right: nil, symbol: 2}]

    result_3 =
      Challenge61A.leaves(%TreeNode{
        symbol: 1,
        left: %TreeNode{symbol: 2, left: nil, right: nil},
        right: %TreeNode{symbol: 3, left: nil, right: nil}
      })

    desired_result_3 = state[:leaves_result_list]

    assert Helpers.check_two_enumerables_equal?(result_3, desired_result_3)
  end
end
