defmodule Challenge16Test do
  use ExUnit.Case

  test "drop" do
    assert Challenge16.drop(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3) == [
             "a",
             "b",
             "d",
             "e",
             "g",
             "h",
             "k"
           ]

    assert Challenge16.drop([], 1) == []
    assert Challenge16.drop(["a"], 1) == []
  end

  test "drop_another_version" do
    assert Challenge16.drop_another_version(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3) ==
             [
               "a",
               "b",
               "d",
               "e",
               "g",
               "h",
               "k"
             ]

    assert Challenge16.drop_another_version([], 1) == []
    assert Challenge16.drop_another_version(["a"], 1) == []
  end

  test "drop_using_recursion" do
    assert Challenge16.drop_using_recursion(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3) ==
             ["a", "b", "d", "e", "g", "h", "k"]

    assert Challenge16.drop_using_recursion([], 1) == []
    assert Challenge16.drop_using_recursion(["a"], 1) == []
  end
end
