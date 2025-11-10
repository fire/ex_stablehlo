defmodule Challenge50 do
  @moduledoc """
  (***) Huffman codes.

  We suppose a set of symbols with their frequencies, given as a list of fr(S,F) terms.
  Example: [fr(a,45),fr(b,13),fr(c,12),fr(d,16),fr(e,9),fr(f,5)]. Our objective is to construct a list hc(S,C) terms,
  where C is the Huffman code word for the symbol S.
  In our example, the result could be Hs = [hc(a,'0'), hc(b,'101'), hc(c,'100'), hc(d,'111'), hc(e,'1101'), hc(f,'1100')] [hc(a,'01'),...etc.].
  """
  def huffman(symbols_with_frequencies) do
    nodes_list =
      symbols_with_frequencies
      |> Enum.map(fn {symbol, weight} ->
        %TreeNodeWithWeight{symbol: symbol, weight: weight, left: nil, right: nil}
      end)

    huffman_tree = huffman_tree_gen(nodes_list)
    huffman_tree |> traverse_huffman_tree("") |> List.flatten()
  end

  defp traverse_huffman_tree(node, acc) do
    if TreeNodeWithWeight.is_leaf(node) do
      [{node.symbol, acc}]
    else
      Enum.concat(
        traverse_huffman_tree(node.left, acc <> "0"),
        traverse_huffman_tree(node.right, acc <> "1")
      )
    end
  end

  defp huffman_tree_gen([head_node]), do: head_node

  defp huffman_tree_gen(nodes_lst) do
    a = find_min_elem(nodes_lst)
    nodes_lst = reject_node_from_lst(nodes_lst, a)
    b = find_min_elem(nodes_lst)
    nodes_lst = reject_node_from_lst(nodes_lst, b)

    huffman_tree_gen([
      %TreeNodeWithWeight{weight: a.weight + b.weight, symbol: nil, left: a, right: b} | nodes_lst
    ])
  end

  defp reject_node_from_lst(nodes_lst, node) do
    Enum.reject(nodes_lst, &(&1 == node))
  end

  defp find_min_elem(nodes_lst) do
    Enum.reduce(nodes_lst, fn elem, acc ->
      if elem.weight <= acc.weight, do: elem, else: acc
    end)
  end
end
