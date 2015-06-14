defmodule FriendsAndRelationsTest do
  use ExUnit.Case

  import Schemer.FriendsAndRelations

  test "is_set" do
    refute is_set [:apple, :peaches, :apple, :plum]
    assert is_set [:apple, :peaches, :pears, :plums]
    assert is_set []
  end

  test "makeset" do
    assert makeset([:apple, :peach, :pear, :peach, :plum, :apple, :lemon, :peach]) ==
      [:pear, :plum, :apple, :lemon, :peach]
  end

  test "is_subset" do
    assert is_subset([5, :chicken, :wings], [6, :sodas, :and, :wings, :chicken, 5])
    refute is_subset([:a, :b, :c], [:a, :d, :e])
  end

  test "eqset" do
    assert eqset(
      [6, :large, :chickens, :with, :wings],
      [6, :chickens, :with, :large, :wings]
    )
  end

  test "has_intersect" do
    assert has_intersect(
      [:stewed, :tomatoes, :and, :macaroni],
      [:macaroni, :and, :cheese]
    )
  end

  test "intersect" do
    assert intersect([:stewed, :tomatoes, :and, :macaroni], [:macaroni, :and, :cheese])
      == [:and, :macaroni]
  end

  test "union" do
    assert union(
      [:stewed, :tomatoes, :and, :macaroni, :casserole],
      [:macaroni, :and, :cheese]
    ) == [:stewed, :tomatoes, :casserole, :macaroni, :and, :cheese]
  end

  test "intersectall" do
    assert intersectall([
      [:a, :b, :c],
      [:c, :a, :d, :e],
      [:e, :f, :g, :a, :b]
    ]) == [:a]
  end

  test "is_pair" do
    assert is_pair([:pear, :pear])
    assert is_pair([3, 7])
    assert is_pair([[2], [:pair]])
    assert is_pair([:full, [:house]])
    refute is_pair([])
    refute is_pair([1])
    refute is_pair([1,2,3])
  end

  test "helpers" do
    assert first([1,2,3])  == 1
    assert second([1,2,3]) == 2
    assert third([1,2,3])  == 3

    assert build([:a,:b,:c], [1,2,3]) == [[:a, :b, :c], [1,2,3]]
  end

  test "is_fun" do
    assert is_fun([[:a, :b], [:c, :d], [:d, :b]])
    refute is_fun([[:a, :b], [:c, :d], [:a, :e]])
  end

  test "revrel" do
    assert revrel([[8, :a], [:pumpkin, :pie], [:got, :sick]]) ==
      [[:a, 8], [:pie, :pumpkin], [:sick, :got]]
  end

  test "is_fullfun" do
    refute is_fullfun([[:grape, :raisin], [:plume, :prune], [:stewed, :prune]])
    assert is_fullfun([[:grape, :raisin], [:plume, :prune], [:stewed, :grape]])
  end
end
