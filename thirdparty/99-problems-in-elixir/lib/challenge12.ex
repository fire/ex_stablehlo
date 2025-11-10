defmodule Challenge12 do
  @moduledoc """
  (**) Decode a run-length encoded list.
    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
  """
  def decode(lst) do
    reversed_lst =
      Enum.reduce(lst, [], fn item, acc ->
        case item do
          {count, letter} -> Enum.concat(List.duplicate(letter, count), acc)
          _ -> [item | acc]
        end
      end)

    Enum.reverse(reversed_lst)
  end

  @doc """
  (**) Decode a run-length encoded list.
    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
  """
  def decode_my1(lst) do
    list_of_lists =
      for item <- lst do
        case item do
          {count, letter} -> List.duplicate(letter, count)
          _ -> [item]
        end
      end

    List.flatten(list_of_lists)
  end

  @doc """
  (**) Decode a run-length encoded list.
    Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
  """
  def decode_my2(lst) do
    reversed_lst =
      for item <- lst, reduce: [] do
        acc when is_tuple(item) and tuple_size(item) == 2 ->
          {count, letter} = item
          Enum.concat(List.duplicate(letter, count), acc)

        acc ->
          [item | acc]
      end

    Enum.reverse(reversed_lst)
  end
end
