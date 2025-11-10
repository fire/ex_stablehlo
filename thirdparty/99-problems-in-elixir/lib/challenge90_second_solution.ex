defmodule Challenge90SecondSolution do
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

  @left 1..64//8
  @right 8..64//8
  @top 57..64
  @bottom 1..8

  @letters Map.new(Enum.zip(1..8, [:a, :b, :c, :d, :e, :f, :g, :h]))

  def solve() do
    # a,b,c ... are columns values,
    # i.e.
    #      a = [1, 9, 17, 25, 33, 41, 49, 57],
    #      b = [2, 10, 18, 26, 34, 42, 50, 58]
    #      c = [3, 11, 19, 27, 35, 43, 51, 59]
    #      ...
    for a <- @left,
        b <- 2..64//8,
        c <- 3..64//8,
        d <- 4..64//8,
        e <- 5..64//8,
        f <- 6..64//8,
        g <- 7..64//8,
        h <- @right,
        length(
          Enum.uniq_by([a, b, c, d, e, f, g, h], fn queen ->
            div(queen - 1, 8)
          end)
        ) == 8,
        suitable_positions([a, b, c, d, e, f, g, h]),
        do:
          Enum.map([a, b, c, d, e, f, g, h], fn index ->
            remainder = rem(index, 8)

            y = if remainder > 0, do: div(index, 8) + 1, else: div(index, 8)

            x = if remainder > 0, do: remainder, else: 8

            {@letters[x], y}
          end)
  end

  defp suitable_positions([head | tail]) do
    result =
      Enum.reduce_while(tail, [head], fn val, acc ->
        if is_suitable_place_for_new_queen(acc, val) do
          {:cont, [val | acc]}
        else
          {:halt, nil}
        end
      end)

    !is_nil(result)
  end

  defp is_suitable_place_for_new_queen(present_queens, queen) do
    Enum.all?(present_queens, fn present_queen ->
      check_if_new_queen_is_not_hit_by_present_queen(present_queen, queen)
    end)
  end

  defp is_within_gamefield_fn(index), do: index != -1

  defp check_if_new_queen_is_not_hit_by_present_queen(
         present_queen,
         new_queen
       ) do
    # returns true if it is not hit by the present queen
    # left bottom deck's corner is (1, 1)

    move_leftx_upy_corner_stream =
      Stream.iterate(new_queen, fn pos ->
        if pos in @left || pos in @top, do: -1, else: pos + 8 - 1
      end)

    move_rightx_upy_corner_stream =
      Stream.iterate(new_queen, fn pos ->
        if pos in @right || pos in @top, do: -1, else: pos + 8 + 1
      end)

    move_leftx_downy_corner_stream =
      Stream.iterate(new_queen, fn pos ->
        if pos in @left || pos in @bottom, do: -1, else: pos - 8 - 1
      end)

    move_rightx_downy_corner_stream =
      Stream.iterate(new_queen, fn pos ->
        if pos in @right || pos in @bottom, do: -1, else: pos - 8 + 1
      end)

    reduce_stream_fn = fn stream ->
      Enum.reduce_while(stream, true, fn val, acc ->
        cond do
          !is_within_gamefield_fn(val) -> {:halt, acc}
          val == present_queen -> {:halt, false}
          true -> {:cont, true}
        end
      end)
    end

    Enum.all?(
      [
        move_leftx_upy_corner_stream,
        move_rightx_upy_corner_stream,
        move_leftx_downy_corner_stream,
        move_rightx_downy_corner_stream
      ],
      reduce_stream_fn
    )
  end
end
