defmodule Challenge28Test do
  use ExUnit.Case

  test "lsort" do
    assert Challenge28.lsort([
             ["a", "b", "c"],
             ["d", "e"],
             ["f", "g", "h"],
             ["d", "e"],
             ["i", "j", "k", "l"],
             ["m", "n"],
             ["o"]
           ]) ==
             [
               ["o"],
               ["d", "e"],
               ["d", "e"],
               ["m", "n"],
               ["a", "b", "c"],
               ["f", "g", "h"],
               ["i", "j", "k", "l"]
             ]

    assert Challenge28.lsort_another_version([
             ["a", "b", "c"],
             ["d", "e"],
             ["f", "g", "h"],
             ["d", "e"],
             ["i", "j", "k", "l"],
             ["m", "n"],
             ["o"]
           ]) ==
             [
               ["o"],
               ["d", "e"],
               ["d", "e"],
               ["m", "n"],
               ["a", "b", "c"],
               ["f", "g", "h"],
               ["i", "j", "k", "l"]
             ]
  end

  test "lfsort" do
    assert Challenge28.lfsort([
             ["a", "b", "c"],
             ["d", "e"],
             ["f", "g", "h"],
             ["d", "e"],
             ["i", "j", "k", "l"],
             ["m", "n"],
             ["o"]
           ]) == [
             ["i", "j", "k", "l"],
             ["o"],
             ["a", "b", "c"],
             ["f", "g", "h"],
             ["d", "e"],
             ["d", "e"],
             ["m", "n"]
           ]
  end
end
