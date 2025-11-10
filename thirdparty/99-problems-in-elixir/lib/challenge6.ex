defmodule Challenge6 do
  @moduledoc """
  (*) Find out whether a list is a palindrome.
  """
  def is_palindrome(lst), do: lst == Challenge5.reverse(lst)
end
