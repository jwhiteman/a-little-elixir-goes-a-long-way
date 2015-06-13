defmodule LambdaTheUltimateTest do
  use ExUnit.Case

  import Schemer.LambdaTheUltimate
  import Schemer.FullOfStars

  test "rember-f" do
    assert rember_f(&equal/2, 5, [6, 2, 5, 3]) == [6, 2, 3]

    assert rember_f(&equal/2, :jelly, [:jelly, :beans, :are, :good]) ==
      [:beans, :are, :good]

    assert rember_f(
      &equal/2, [:pop, :corn], [:lemonade, [:pop, :corn], :and, [:cake]]
    ) == [:lemonade, :and, [:cake]]
  end

  test "eq_salad" do
    assert eq_salad.(:salad)
    refute eq_salad.(:fruit)
  end

  test "rember-f-curry" do
    assert rember_f_curry(&(&1 == &2)).(5, [6, 2, 5, 3]) == [6, 2, 3]
  end

  test "insertL-f" do
    assert insertL_f(&(&1 == &2)).(:a, :c, [:c, :d, :c]) == [:a, :c, :d, :c]
  end

  test "insertR-f" do
    assert insertR_f(&(&1 == &2)).(:c, :a, [:a, :d, :c]) == [:a, :c, :d, :c]
  end

  test "insert-g" do
    assert insert_g(&seqL/3).(:a, :c, [:c, :d, :c]) == [:a, :c, :d, :c]
    assert insert_g(&seqR/3).(:c, :a, [:a, :d, :c]) == [:a, :c, :d, :c]
  end

  test "subst" do
    assert subst(:elixir, :erlang, [:my, :other, :erlang, :is, :an, :elixir]) ==
      [:my, :other, :elixir, :is, :an, :elixir]
  end

  test "rember" do
    assert rember(:worm, [:apple, :apple, :worm, :apple]) == [:apple, :apple, :apple]
  end

  test "value" do
    assert value([1, :+, [3, :*, 4]]) == 13
  end

  test "multirember-f" do
    assert multirember_f(&(&1 == &2)).(:c, [:a, :c, :d, :c]) == [:a, :d]
  end

  test "multirember_eq" do
    assert multirember_eq.(:c, [:a, :c, :d, :c]) == [:a, :d]
  end

  test "multiremberT" do
    assert multiremberT(&(&1 == :tuna)).([:shrimp, :salad, :tuna, :salad, :and, :tuna]) ==
      [:shrimp, :salad, :salad, :and]
  end

  test "multirember_and_co" do
    assert multirember_and_co(
      :a,
      [:x, :y, :z, :a, :b, :a, :a, :a, :c], 
      &( [&1 | [&2 | []]] )
   ) == [[:x, :y, :z, :b, :c], [:a, :a, :a, :a]]

   assert multirember_and_co(
     :tuna,
     [:strawberries, :tuna, :and, :swordfish],
     fn (seen, _) -> length(seen) end
   ) == 3
  end

  test "multiinsertLR" do
    assert multiinsertLR(:zap, :l, :r, [:l, :x, :r, :x]) == [:zap, :l, :x, :r, :zap, :x]
  end

  test "multiinsertLR_and_co" do
    assert multiinsertLR_and_co(
      :zap,
      :l,
      :r,
      [:l, :x, :r, :x, :r, :l, :r],
      fn (left, right) -> [left, right] end
    ) == [2, 3]
  end

end
