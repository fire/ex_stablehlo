defmodule Challenge63Test do
  use ExUnit.Case

  test "complete_binary_tree" do
    assert Challenge63.complete_binary_tree(0) == nil

    assert Challenge63.complete_binary_tree(1) == %TreeNode{
             symbol: 1,
             left: nil,
             right: nil
           }

    assert Challenge63.complete_binary_tree(2) == %TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: nil
           }

    assert Challenge63.complete_binary_tree(3) == %TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: %TreeNode{symbol: 3, left: nil, right: nil}
           }

    assert Challenge63.complete_binary_tree(4) == %TreeNode{
             symbol: 1,
             left: %TreeNode{
               symbol: 2,
               left: %TreeNode{symbol: 4, left: nil, right: nil},
               right: nil
             },
             right: %TreeNode{symbol: 3, left: nil, right: nil}
           }
  end
end
