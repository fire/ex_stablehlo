defmodule Challenge59Test do
  use ExUnit.Case

  test "hbal_tree" do
    assert Challenge59.hbal_tree(0) == [nil]
    assert Challenge59.hbal_tree(1) == [%TreeNode{symbol: :x, left: nil, right: nil}]
    assert Challenge59.hbal_tree(2) == [
      %TreeNode{symbol: :x, left: %TreeNode{symbol: :x, left: nil, right: nil}, right: nil},
      %TreeNode{symbol: :x, left: nil, right: %TreeNode{symbol: :x, left: nil, right: nil}},
      %TreeNode{symbol: :x, left: %TreeNode{symbol: :x, left: nil, right: nil}, right: %TreeNode{symbol: :x, left: nil, right: nil}}
    ]

    hbal_tree_3 = Challenge59.hbal_tree(3)
    assert length(hbal_tree_3) == 15
    assert length(Enum.uniq(hbal_tree_3)) == 15

    hbal_tree_4 = Challenge59.hbal_tree(4)
    assert length(hbal_tree_4) == 315
    assert length(Enum.uniq(hbal_tree_4)) == 315
  end
end