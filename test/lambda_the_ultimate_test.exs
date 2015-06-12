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
    assert eq_salad.(:salad) == true
    assert eq_salad.(:fruit) == false
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

end
