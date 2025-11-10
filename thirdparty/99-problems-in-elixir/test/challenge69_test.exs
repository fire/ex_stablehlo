defmodule Challenge69Test do
  use ExUnit.Case

  setup_all do
    {:ok,
     empty_tree: %TreeNode{symbol: "a", left: nil, right: nil},
     some_tree: %TreeNode{
       symbol: "a",
       left: %TreeNode{
         symbol: "b",
         left: %TreeNode{symbol: "d", left: nil, right: nil},
         right: %TreeNode{symbol: "e", left: nil, right: nil}
       },
       right: %TreeNode{
         symbol: "c",
         left: nil,
         right: %TreeNode{
           symbol: "f",
           left: %TreeNode{symbol: "g", left: nil, right: nil},
           right: nil
         }
       }
     }}
  end

  test "dotstring_to_tree", state do
    empty_tree = state[:empty_tree]
    assert Challenge69.dotstring_to_tree(Challenge69.dotstring(empty_tree)) == empty_tree

    some_tree = state[:some_tree]
    assert Challenge69.dotstring_to_tree(Challenge69.dotstring(some_tree)) == some_tree
  end

  test "dotstring", state do
    assert Challenge69.dotstring(state[:empty_tree]) == "a.."

    assert Challenge69.dotstring(state[:some_tree]) == "abd..e..c.fg..."
  end
end
