defmodule ConsTheMagnificentTest do
  use ExUnit.Case

  import Schemer.ConsTheMagnificent

  test "rember" do
    [:lamb, :chops, :and, :jelly] =
      rember(:mint, [:lamb, :chops, :and, :mint, :jelly])

    [:lamb, :chops, :and, :flavored, :mint, :jelly]
      rember(:mint, [:lamb, :chops, :and, :mint, :flavored, :mint, :jelly])

    [:bacon, :lettuce, :and, :tomato] =
      rember(:toast, [:bacon, :lettuce, :and, :tomato])

    [:coffee, :tea, :cup, :hick, :cup] =
      rember(:cup, [:coffee, :cup, :tea, :cup, :hick, :cup])
  end

  test "firsts" do
    [:apple, :plum, :grape, :bean] =
      firsts([[:apple, :peach, :pumpkin],
                       [:plum, :pear, :cherry],
                       [:grape, :raisin, :pea],
                       [:bean, :carrot, :eggplant]])

    [:a, :c, :e] =
      firsts([[:a, :b], [:c, :d], [:e, :f]])

    [] = firsts([])

    [:five, :four, :eleven] =
      firsts([[:five, :plums], [:four], [:eleven, :green, :oranges]])
  end

  test "insertR" do
    [:ice, :cream, :with, :fudge, :topping, :for, :desert] =
      insertR(:topping, :fudge, [:ice, :cream, :with, :fudge, :for, :desert])

    [:tacos, :tamales, :and, :jalapeno, :salsa] =
      insertR(:jalapeno, :and, [:tacos, :tamales, :and, :salsa])

    [:a, :b, :c, :d, :e, :f, :g, :h] =
      insertR(:e, :d, [:a, :b, :c, :d, :f, :g, :h])
  end

  test "insertL" do
    [:a, :b, :c, :x, :y, :z] = insertL(:x, :y, [:a, :b, :c, :y, :z])
  end

  test "subst" do
    [:ice, :cream, :with, :topping, :for, :desert] =
      subst(:topping, :fudge, [:ice, :cream, :with, :fudge, :for, :desert])

    [:this, :foo, :is, :for, :you]
      subst(:foo, :bar, [:this, :bar, :is, :for, :you])
  end

  test "subst2" do
    [:vanilla, :ice, :cream, :with, :chocolate, :topping] =
      subst2(:vanilla, :chocolate, :banana,
                      [:banana, :ice, :cream, :with, :chocolate, :topping])
  end

  test "multirember" do
    [:coffee, :tea, :and, :hick] =
      multirember(:cup, [:coffee, :cup, :tea, :cup, :and, :hick, :cup])
  end

  test "multiinsertR" do
    [:a, :y, :x, :b, :y, :x] = multiinsertR(:x, :y, [:a, :y, :b, :y])
  end

  test "multiinsertL" do
    [:a, :x, :y, :b, :x, :y] = multiinsertL(:x, :y, [:a, :y, :b, :y])
  end

  test "mutlisubst" do
    [:my, :other, :foo, :is, :a, :foo] =
      multisubst(:foo, :bar, [:my, :other, :bar, :is, :a, :bar])
  end
end
