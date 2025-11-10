defmodule Challenge64Test do
  use ExUnit.Case

  test "layout_binary_tree" do
    assert Challenge64.layout_binary_tree(nil) == ""

    assert Challenge64.layout_binary_tree(%TreeNode{
             symbol: "a",
             left: nil,
             right: nil
           }) == "(a 0 1 nil nil)"

    assert Challenge64.layout_binary_tree(%TreeNode{
             symbol: "a",
             left: %TreeNode{
               symbol: "b",
               left: %TreeNode{symbol: "c", left: nil, right: nil},
               right: nil
             },
             right: %TreeNode{symbol: "d", left: nil, right: nil}
           }) == "(a 2 1 (b 1 2 (c 0 3 nil nil) nil) (d 3 2 nil nil))"
  end
end
