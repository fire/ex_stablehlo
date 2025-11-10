defmodule Challenge90ThirdSolution do
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
            {x, y} = index_to_coordinates(index)
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

  defp index_to_coordinates(index) do
    remainder = rem(index, 8)

    y = if remainder > 0, do: div(index, 8) + 1, else: div(index, 8)

    x = if remainder > 0, do: remainder, else: 8

    {x, y}
  end

  defp is_suitable_place_for_new_queen(present_queens, queen) do
    Enum.all?(present_queens, fn present_queen ->
      {present_queen_x, present_queen_y} = index_to_coordinates(present_queen)
      {queen_x, queen_y} = index_to_coordinates(queen)

      # check they're not on the same diagonal
      abs(present_queen_x - queen_x) != abs(present_queen_y - queen_y)
    end)
  end
end
