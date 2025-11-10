defmodule Challenge90 do
  @moduledoc """
    (**) Eight queens problem
        This is a classical problem in computer science.
        The objective is to place eight queens on a chessboard so that no two queens are attacking each other;
        i.e., no two queens are in the same row, the same column, or on the same diagonal.

        Hint: Represent the positions of the queens as a list of numbers 1..N.
        Example: (4 2 7 3 6 8 5 1) means that the queen in the first column is in row 4,
        the queen in the second column is in row 2, etc.
        Use the generate-and-test paradigm.
  """

  @letters Map.new(Enum.zip(1..8, [:a, :b, :c, :d, :e, :f, :g, :h]))
  @board_axis_indexes 1..8

  defp create_board() do
    Enum.reduce(@board_axis_indexes, Map.new(), fn x, acc_tmp ->
      board_tmp = acc_tmp

      Enum.reduce(@board_axis_indexes, board_tmp, fn y, acc ->
        Map.put(acc, (x - 1) * 8 + y, {x, y})
      end)
    end)
  end

  def solve() do
    board = create_board()

    for a <- 1..64//8,
        b <- 2..64//8,
        c <- 3..64//8,
        d <- 4..64//8,
        e <- 5..64//8,
        f <- 6..64//8,
        g <- 7..64//8,
        h <- 8..64//8,
        length(
          Enum.uniq_by([a, b, c, d, e, f, g, h], fn queen ->
            div(queen - 1, 8)
          end)
        ) == 8,
        suitable_positions(
          board[a],
          board[b],
          board[c],
          board[d],
          board[e],
          board[f],
          board[g],
          board[h]
        ),
        do:
          Enum.map(
            [board[a], board[b], board[c], board[d], board[e], board[f], board[g], board[h]],
            fn {x, y} ->
              {@letters[y], x}
            end
          )
  end

  defp suitable_positions(pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8) do
    is_suitable_place_for_new_queen([pos1], pos2) and
      is_suitable_place_for_new_queen([pos1, pos2], pos3) and
      is_suitable_place_for_new_queen([pos1, pos2, pos3], pos4) and
      is_suitable_place_for_new_queen([pos1, pos2, pos3, pos4], pos5) and
      is_suitable_place_for_new_queen([pos1, pos2, pos3, pos4, pos5], pos6) and
      is_suitable_place_for_new_queen([pos1, pos2, pos3, pos4, pos5, pos6], pos7) and
      is_suitable_place_for_new_queen([pos1, pos2, pos3, pos4, pos5, pos6, pos7], pos8)
  end

  defp is_suitable_place_for_new_queen(present_queens, queen) do
    Enum.all?(present_queens, fn present_queen ->
      check_if_new_queen_is_not_hit_by_present_queen(present_queen, queen)
    end)
  end

  defp check_if_new_queen_is_not_hit_by_present_queen(
         present_queen,
         new_queen
       ) do
    # returns true if it is not hit by the present queen
    # left bottom deck's corner is (1, 1)

    inc_fn = fn x -> x + 1 end
    dec_fn = fn x -> x - 1 end

    modify_pos_builder_fn = fn xfnmod, yfnmod -> fn {x, y} -> {xfnmod.(x), yfnmod.(y)} end end

    is_within_gamefield_fn? = fn {x, y} ->
      x in @board_axis_indexes and y in @board_axis_indexes
    end

    leftx_upy_modify_fn = modify_pos_builder_fn.(dec_fn, inc_fn)
    rightx_upy_modify_fn = modify_pos_builder_fn.(inc_fn, inc_fn)

    leftx_downy_modify_fn = modify_pos_builder_fn.(dec_fn, dec_fn)
    rightx_downy_modify_fn = modify_pos_builder_fn.(inc_fn, dec_fn)

    pred_fn = fn item -> item != present_queen end

    check_while = fn while_fn, pred_fn, modify_val_fn ->
      fn me, val ->
        if !while_fn.(val) do
          true
        else
          if !pred_fn.(val) do
            false
          else
            me.(me, modify_val_fn.(val))
          end
        end
      end
    end

    check_while_leftx_upy_instance_fn =
      check_while.(is_within_gamefield_fn?, pred_fn, leftx_upy_modify_fn)

    check_while_rightx_upy_modify_fn =
      check_while.(is_within_gamefield_fn?, pred_fn, rightx_upy_modify_fn)

    check_while_leftx_downy_modify_fn =
      check_while.(is_within_gamefield_fn?, pred_fn, leftx_downy_modify_fn)

    check_while_rightx_downy_modify_fn =
      check_while.(is_within_gamefield_fn?, pred_fn, rightx_downy_modify_fn)

    check_while_leftx_upy_instance_fn.(check_while_leftx_upy_instance_fn, new_queen) and
      check_while_rightx_upy_modify_fn.(check_while_rightx_upy_modify_fn, new_queen) and
      check_while_leftx_downy_modify_fn.(check_while_leftx_downy_modify_fn, new_queen) and
      check_while_rightx_downy_modify_fn.(check_while_rightx_downy_modify_fn, new_queen)
  end
end
