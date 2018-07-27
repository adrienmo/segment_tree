defmodule SegmentTree do
  @moduledoc """
  Data structure to compute efficiently operation on ranges.

  ## Problem
  Given a range [0, n-1] of n values, we want to efficiently calculate an operation (e.g. sum), a naive approach is to
  iterate through a list but we will get the answer in O(n) time.

      list = [a, b, ..., z]
      list_cut = cut(list, k, n)
      sum = Enum.sum(list_cut)

  If many random ranges must be computed on this list we can use a more efficient approach using SegmentTree

      segment_tree = SegmentTree.new(n, &Kernel.+/2)
      segment_tree = populate(segment_tree, list)
      sum = SegmentTree.aggregate(segment_tree, k, n)

  We will then be able to get an answer in O(log(n)) time.
  """

  defstruct [:max_index, :aggregate_fun, :tree, :default]

  @type t :: %__MODULE__{
               max_index: non_neg_integer,
               aggregate_fun: (term, term -> term),
               tree: map,
               default: term
             }

  @doc """
  Create a new SegmentTree structure

  max_index must be higher than any index used in the range
  ## Examples
      SegmentTree.new(1_000, &Kernel.+/2)
      #=> %SegmentTree{default: 0, tree: %{}, aggregate_fun: &Kernel.+/2, max_index: 1_023}
  """
  @spec new(non_neg_integer, (term, term -> term), term) :: SegmentTree.t
  def new(max_index, aggregate_fun, default \\ 0) do
    max_index = round(:math.pow(2, round(:math.ceil(:math.log2(max_index))))) - 1
    %SegmentTree{max_index: max_index, aggregate_fun: aggregate_fun, tree: %{}, default: default}
  end

  @doc """
  Insert element in SegmentTree at the given index

  ## Examples
      SegmentTree.put(%SegmentTree{...}, 10, 29)
      #=> %SegmentTree{...}
  """
  @spec put(SegmentTree.t, non_neg_integer, term) :: SegmentTree.t
  def put(segment_tree, index, value) do
    put(segment_tree, 0, 0, segment_tree.max_index, index, value)
  end

  defp put(segment_tree, tree_index, min, max, index, value) do
    new_tree =
      Map.update(segment_tree.tree, tree_index, value, &segment_tree.aggregate_fun.(&1, value))

    segment_tree = %{segment_tree | tree: new_tree}
    mid = min + round((max - min + 1) / 2)

    cond do
      min == max -> segment_tree
      index < mid -> put(segment_tree, tree_index * 2 + 1, min, mid - 1, index, value)
      index >= mid -> put(segment_tree, tree_index * 2 + 2, mid, max, index, value)
    end
  end

  @doc """
  Compute range value of a SegmentTree between min and max

  ## Examples
      SegmentTree.aggregate(%SegmentTree{...}, 10, 29)
      #=> %SegmentTree{...}
  """
  @spec aggregate(SegmentTree.t, non_neg_integer, non_neg_integer) :: term
  def aggregate(segment_tree, range_min, range_max) do
    aggregate(segment_tree, 0, 0, segment_tree.max_index, range_min, range_max)
  end

  defp aggregate(segment_tree, _, min, max, range_min, range_max)
      when max < range_min or min > range_max,
      do: segment_tree.default

  defp aggregate(%{tree: tree, default: default}, tree_index, min, max, range_min, range_max)
      when range_min <= min and max <= range_max,
      do: Map.get(tree, tree_index, default)

  defp aggregate(segment_tree, tree_index, min, max, range_min, range_max) do
    mid = min + round((max - min + 1) / 2)

    agg1 = aggregate(segment_tree, tree_index * 2 + 1, min, mid - 1, range_min, range_max)
    agg2 = aggregate(segment_tree, tree_index * 2 + 2, mid, max, range_min, range_max)

    segment_tree.aggregate_fun.(agg1, agg2)
  end
end
