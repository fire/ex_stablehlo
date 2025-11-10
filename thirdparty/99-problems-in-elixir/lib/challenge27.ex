defmodule Challenge27 do
  @moduledoc """
    (**) Group the elements of a set into disjoint subsets.
    a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons?
    Write a function that generates all the possibilities and returns them in a list.

    Example:
    * (group3 '(aldo beat carla david evi flip gary hugo ida))
    ( ( (ALDO BEAT) (CARLA DAVID EVI) (FLIP GARY HUGO IDA) )
    ... )

    b) Generalize the above function in a way that we can specify a list of group sizes
    and the function will return a list of groups.

    Example:
    * (group '(aldo beat carla david evi flip gary hugo ida) '(2 2 5))
    ( ( (ALDO BEAT) (CARLA DAVID) (EVI FLIP GARY HUGO IDA) )
    ... )

    Note that we do not want permutations of the group members; i.e. ((ALDO BEAT) ...)  is the same solution as ((BEAT ALDO) ...).
    However, we make a difference between ((ALDO BEAT) (CARLA DAVID) ...) and ((CARLA DAVID) (ALDO BEAT) ...).

    You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients".
  """

  def group(people, group_counts_list) do
    if Enum.sum(group_counts_list) != length(people) do
      raise("Invalid group counts provided")
    else
      group_impl(people, fn a, b, c, d, e, f, g, h, i ->
        elems = [a, b, c, d, e, f, g, h, i]

        Enum.reduce(group_counts_list, {elems, []}, fn group_count, {cur_elems_seq, result} ->
          {left, right} = Enum.split(cur_elems_seq, group_count)
          {right, [left | result]}
        end)
        |> Kernel.elem(1)
      end)
    end
  end

  def group3(people) do
    group_impl(people, fn a, b, c, d, e, f, g, h, i -> [[a, b], [c, d, e], [f, g, h, i]] end)
  end

  defp previously_found?(new_elem, acc) do
    Enum.find(acc, fn test_elem ->
      paired_groups =
        Enum.zip(new_elem, test_elem)

      Enum.all?(paired_groups, fn {x, y} -> Enum.sort(x) == Enum.sort(y) end)
    end)
  end

  defp group_impl(people, get_new_elem_fn) do
    # bruteforce way!
    for a <- people,
        b <- people -- [a],
        c <- people -- [a, b],
        d <- people -- [a, b, c],
        e <- people -- [a, b, c, d],
        f <- people -- [a, b, c, d, e],
        g <- people -- [a, b, c, d, e, f],
        h <- people -- [a, b, c, d, e, f, g],
        i <- people -- [a, b, c, d, e, f, g, h],
        reduce: [] do
      acc ->
        new_elem = get_new_elem_fn.(a, b, c, d, e, f, g, h, i)

        if previously_found?(new_elem, acc) do
          acc
        else
          [new_elem | acc]
        end
    end
  end
end
