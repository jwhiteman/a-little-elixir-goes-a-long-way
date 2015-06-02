defmodule FullOfStarsTest do
  use ExUnit.Case

  import Schemer.FullOfStars

  test "rember_star" do
    assert rember_star(:cup, [
                               [:coffee], :cup,
                               [[:tea], :cup],
                               [:and, [:hick]], :cup
                             ]
    ) == [[:coffee], [[:tea]], [:and, [:hick]]]
  end

  test "insert_right_star" do
    assert insert_right_star(:roast, :chuck, [[:how, :much, [:wood]], :could,
                                     [[:a, [:wood], :chuck]],
                                     [[[:chuck]]],
                                     [:if, [:a], [[:wood, :chuck]],
                                     :could, :chuck, :wood]]) ==
    [[:how, :much, [:wood]], :could, [[:a, [:wood], :chuck, :roast]],
    [[[:chuck, :roast]]], [:if, [:a], [[:wood, :chuck, :roast]],
     :could, :chuck, :roast, :wood]]

  end

  test "occur_star" do
    assert occur_star(:banana, [[:banana], [:split, [[[[:banana, :ice]]],
                                [:cream, [:banana]], :sherbet]], [:banana],
                                [:bread], [:banana, :brandy]]) == 5
  end

  test "subst_star" do
    assert subst_star(:orange, :banana, [[:banana], [:split, [[[[:banana, :ice]]],
                            [:cream, [:banana]], :sherbet]], [:banana],
                            [:bread], [:banana, :brandy]]) ==
    [[:orange], [:split, [[[[:orange, :ice]]],
     [:cream, [:orange]], :sherbet]], [:orange],
     [:bread], [:orange, :brandy]]
  end

  test "insert_left_star" do
    assert insert_left_star(:pecker, :chuck, [[:how, :much, [:wood]], :could,
                                             [[:a, [:wood], :chuck]],
                                             [[[:chuck]]],
                                             [:if, [:a], [[:wood, :chuck]],
                                             :could, :chuck, :wood]
                                            ]
    ) ==
    [[:how, :much, [:wood]], :could, [[:a, [:wood], :pecker, :chuck]],
    [[[:pecker, :chuck]]], [:if, [:a], [[:wood, :pecker, :chuck]],
     :could, :pecker, :chuck, :wood]]
  end

  test "member_star" do
    assert member_star(:chips, [[:potato], [:chips, [[:with], :fisth], [:chips]]]) == true
  end

  test "leftmost" do
    assert leftmost(
     [[:potato], [:chips, [[:with], :fish], [:chips]]]
    ) == :potato

    assert leftmost(
     [[[:hot], [:tuna, [:and]]], :cheese]
    ) == :hot
  end

  test "eqlist" do
    assert eqlist([:strawberry, :ice, :cream], [:strawberry, :ice, :cream]) == true
    assert eqlist([:strawberry, :ice, :cream], [:strawberry, :cream, :ice]) == false
    assert eqlist([:banana, [[:split]]], [[:banana, [:split]]]) == false
    assert eqlist([:beef, [[:sausage]], [:and, [:soda]]],
                  [:beef, [[:salami]], [:and, [:soda]]]) == false
    assert eqlist([:beef, [[:sausage]], [:and, [:soda]]],
                  [:beef, [[:sausage]], [:and, [:soda]]]) == true
  end
end
