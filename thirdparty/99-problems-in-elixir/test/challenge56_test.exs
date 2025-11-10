defmodule Challenge56Test do
  use ExUnit.Case

  test "is_symmetric" do
    assert Challenge56.is_symmetric(%TreeNode{symbol: :a, left: nil, right: nil}) == true

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: nil,
             right: nil
           }) == true

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: %TreeNode{symbol: :c, left: nil, right: nil},
             right: %TreeNode{symbol: :c, left: nil, right: nil}
           }) == true

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: nil,
             right: %TreeNode{symbol: :c, left: nil, right: nil}
           }) == false

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: %TreeNode{
               symbol: :b,
               left: %TreeNode{symbol: :c, left: nil, right: nil},
               right: nil
             },
             right: %TreeNode{
               symbol: :b,
               left: nil,
               right: %TreeNode{symbol: :c, left: nil, right: nil}
             }
           }) == true

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: %TreeNode{
               symbol: :b,
               left: nil,
               right: %TreeNode{symbol: :c, left: nil, right: nil}
             },
             right: %TreeNode{
               symbol: :b,
               left: %TreeNode{symbol: :c, left: nil, right: nil},
               right: nil
             }
           }) == true

    assert Challenge56.is_symmetric(%TreeNode{
             symbol: :a,
             left: %TreeNode{
               symbol: :b,
               left: %TreeNode{symbol: :c, left: nil, right: nil},
               right: nil
             },
             right: %TreeNode{
               symbol: :b,
               left: nil,
               right: %TreeNode{symbol: :c, left: nil, right: nil}
             }
           }) == true
  end
end
