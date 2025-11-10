defmodule Challenge6Test do
  use ExUnit.Case

  test "is_palindrome" do
    assert Challenge6.is_palindrome(["a", "b", "b", "a"])
    assert Challenge6.is_palindrome([])
    assert Challenge6.is_palindrome(["a"])
    assert !Challenge6.is_palindrome(["a", "b"])
  end
end
