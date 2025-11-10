defmodule Challenge61Test do
  use ExUnit.Case

  test "count_leaves" do
    assert Challenge61.count_leaves(nil) == 0
    assert Challenge61.count_leaves(%TreeNode{symbol: 1, left: nil, right: nil}) == 1

    assert Challenge61.count_leaves(%TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: nil
           }) == 1

    assert Challenge61.count_leaves(%TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: %TreeNode{symbol: 3, left: nil, right: nil}
           }) == 2
  end
end
