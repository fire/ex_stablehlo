defmodule Challenge2Test do
  use ExUnit.Case
  doctest Challenge2

  test "p02_but_last" do
    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last([])
    end

    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last([1])
    end

    assert Challenge2.p02_but_last([1, 2]) == 1
  end

  test "p02_but_last_1" do
    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last_1([])
    end

    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last_1([1])
    end

    assert Challenge2.p02_but_last_1([1, 2]) == 1
  end

  test "p02_but_last_2" do
    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last_2([])
    end

    assert_raise RuntimeError, fn ->
      Challenge2.p02_but_last_2([1])
    end

    assert Challenge2.p02_but_last_2([1, 2]) == 1
  end
end
