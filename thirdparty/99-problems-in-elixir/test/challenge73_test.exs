defmodule Challenge73Test do
  use ExUnit.Case

  setup_all do
    {:ok,
     mtree1: ["a", ["f", "g"], "c", ["b", "d", "e"]],
     mtree2: ["a", "b"],
     mtree3: ["a", "b", "c"],
     mtree4: "a",
     ptl1: "t(a,[t(f,[t(g,[])]),t(c,[]),t(b,[t(d,[]),t(e,[])])])",
     ptl2: "t(a,[t(b,[])])",
     ptl3: "t(a,[t(b,[]),t(c,[])])",
     ptl4: "t(a,[])"}
  end

  test "mtree_ptl", state do
    assert Challenge73.mtree_ptl(state[:mtree1]) == state[:ptl1]
    assert Challenge73.mtree_ptl(state[:mtree2]) == state[:ptl2]
    assert Challenge73.mtree_ptl(state[:mtree3]) == state[:ptl3]
    assert Challenge73.mtree_ptl(state[:mtree4]) == state[:ptl4]
  end

  test "ptl_mtree", state do
    assert Challenge73.ptl_mtree(state[:ptl1]) == state[:mtree1]
    assert Challenge73.ptl_mtree(state[:ptl2]) == state[:mtree2]
    assert Challenge73.ptl_mtree(state[:ptl3]) == state[:mtree3]
    assert Challenge73.ptl_mtree(state[:ptl4]) == state[:mtree4]
  end
end
