defmodule SegmentTreeTest do
  use ExUnit.Case
  doctest SegmentTree

  test "create a new Segment Tree" do
    assert SegmentTree.new(1_000, &Kernel.+/2) == %SegmentTree{
             default: 0,
             tree: %{},
             aggregate_fun: &Kernel.+/2,
             max_index: 1_023
           }

    assert SegmentTree.new(1_000, &Kernel.*/2, 1) == %SegmentTree{
             default: 1,
             tree: %{},
             aggregate_fun: &Kernel.*/2,
             max_index: 1_023
           }
  end

  test "put a new value" do
    segment_tree = SegmentTree.new(1_000, &Kernel.+/2)
    segment_tree2 = SegmentTree.put(segment_tree, 1, 1)
    assert %{
             0 => 1,
             1 => 1,
             3 => 1,
             7 => 1,
             15 => 1,
             31 => 1,
             63 => 1,
             127 => 1,
             255 => 1,
             511 => 1,
             1024 => 1
           } == segment_tree2.tree
    segment_tree3 = SegmentTree.put(segment_tree2, 2, 2)
    assert %{
             0 => 3,
             1 => 3,
             3 => 3,
             7 => 3,
             15 => 3,
             31 => 3,
             63 => 3,
             127 => 3,
             255 => 3,
             511 => 1,
             512 => 2,
             1024 => 1,
             1025 => 2
           } == segment_tree3.tree
  end

  test "test aggregate" do
    segment_tree_sum = Enum.reduce(0..1000, SegmentTree.new(1_000, &Kernel.+/2), fn(x, acc) -> SegmentTree.put(acc, x, x) end)
    assert SegmentTree.aggregate(segment_tree_sum, 101, 1_000) == (1_000 * (1_000 + 1)) / 2 - (100 * (100 + 1)) / 2

    segment_tree_mul = Enum.reduce(1..1000, SegmentTree.new(1_000, &Kernel.*/2, 1), fn(x, acc) -> SegmentTree.put(acc, x, x) end)
    assert SegmentTree.aggregate(segment_tree_mul, 101, 1_000) == div(factorial(1000), factorial(100))
  end

  defp factorial(0), do: 1
  defp factorial(n) when n > 0, do: n * factorial(n - 1)
end
