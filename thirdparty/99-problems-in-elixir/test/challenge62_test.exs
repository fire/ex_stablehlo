defmodule Challenge62Test do
  use ExUnit.Case

  setup_all do
    {:ok,
     internals_result_list: [
       %TreeNode{
         symbol: 1,
         left: %TreeNode{
           symbol: 2,
           left: %TreeNode{symbol: 3, left: nil, right: nil},
           right: nil
         },
         right: %TreeNode{
           symbol: 4,
           left: nil,
           right: %TreeNode{symbol: 5, left: nil, right: nil}
         }
       },
       %TreeNode{
         symbol: 2,
         left: %TreeNode{symbol: 3, left: nil, right: nil},
         right: nil
       },
       %TreeNode{
         symbol: 4,
         left: nil,
         right: %TreeNode{symbol: 5, left: nil, right: nil}
       }
     ]}
  end

  test "internals", state do
    assert Challenge62.internals(nil) == []

    assert Challenge62.internals(%TreeNode{symbol: 1, left: nil, right: nil}) == []

    assert Challenge62.internals(%TreeNode{
             symbol: 1,
             left: %TreeNode{symbol: 2, left: nil, right: nil},
             right: nil
           }) ==
             [
               %TreeNode{
                 symbol: 1,
                 left: %TreeNode{symbol: 2, left: nil, right: nil},
                 right: nil
               }
             ]

    result_3 =
      Challenge62.internals(%TreeNode{
        symbol: 1,
        left: %TreeNode{
          symbol: 2,
          left: %TreeNode{symbol: 3, left: nil, right: nil},
          right: nil
        },
        right: %TreeNode{
          symbol: 4,
          left: nil,
          right: %TreeNode{left: nil, right: nil, symbol: 5}
        }
      })

    desired_result_3 = state[:internals_result_list]

    assert Helpers.check_two_enumerables_equal?(result_3, desired_result_3)
  end
end
