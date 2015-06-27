defmodule Schemer.WhatIsTheValueOfAllOfThisTest do
  use ExUnit.Case

  import Schemer.WhatIsTheValueOfAllOfThis

  test "lookup_in_entry" do
    assert lookup_in_entry(
      :entree,
      [
        [:appetizer, :entree, :beverage],
        [:food, :tastes, :good]
      ],
      fn (_) -> IO.puts "error" end
    ) == :tastes
  end

  test "lookup_in_table" do
    assert lookup_in_table(
      :foo,
      [
        [[:foo, :bar], [42, 2]],
        [[:foo, :bizz], [7, 11]]
      ],
      fn (_) -> IO.puts "error" end
    ) == 42
  end

  test "const_action returns numbers as they are" do
    assert const_action(42, empty_table) == 42
  end

  test "const_action returns booleans as true or false" do
    assert const_action(true, empty_table)
    refute const_action(false, empty_table)
  end

  test "const_action returns labled primitives" do
    assert const_action(:car, empty_table) == [:primitive, :car]
  end

  test "quote_action returns the body of the quote" do
    assert quote_action([:quote, [:foo, :bar]], empty_table) == [:foo, :bar]
  end

  test "identifier_action looks up values in the table" do
    assert identifier_action(:foo, some_table) == 99
  end

  test "identifier_action raises an error if the value is not found" do
    assert_raise RuntimeError, fn ->
      identifier_action(:foo, empty_table)
    end
  end

  test "lambda returns labled non-primitives" do
    assert lambda_action([:lambda, [:x], [:add1, :x]], empty_table) ==
      [:non_primitive, [empty_table, [:x], [:add1, :x]]]
  end

  test "a lambda stores its environment" do
    [_, [table, _, _]] = lambda_action([:lambda, [:x], [:add1, :x]], some_table)

    assert table == some_table
  end

  test "atom_to_action returns const_action for nums, bools, and build-in methods" do
    assert atom_to_action(:car) == &const_action/2
  end

  test "atom_to_action returns identifier_action for everything else" do
    assert atom_to_action(:foo) == &identifier_action/2
  end

  test "list_to_action returns quote, lambda, cond, and application actions" do
    assert list_to_action([:quote, []]) == &quote_action/2
    assert list_to_action([:lambda, [], []]) == &lambda_action/2
    assert list_to_action([:cond, [:else, 42]]) == &cond_action/2
    assert list_to_action([
      [:lambda, [:x], [:add1, :x]],
      42
    ]) == &application_action/2
  end

  test "expression_to_action handles atoms and lists" do
    assert expression_to_action(1)      == &const_action/2
    assert expression_to_action(true)   == &const_action/2
    assert expression_to_action(:car)   == &const_action/2
    assert expression_to_action([:quote, []]) == &quote_action/2
    assert expression_to_action([:lambda, [], []]) == &lambda_action/2
    assert expression_to_action([:cond, [:else, 42]]) == &cond_action/2
    assert expression_to_action([
      [:lambda, [:x], [:add1, :x]],
      42
    ]) == &application_action/2
  end

  test "meaning handles inert actions" do
    assert meaning(42, empty_table) == 42
    assert meaning(false, empty_table) == false
    assert meaning([:quote, [:a, :b, :c]], empty_table) == [:a, :b, :c]
  end

  test "meaning does simple simple actions" do
    assert meaning([:car, [:quote, [1, 2, 3]]], empty_table) == 1
  end

  test "meaning looks up unkown identifiers in the table" do
    assert meaning(:bar, some_table) == 42
  end

  test "cond_action treats else as true" do
    assert cond_action([:cond, [:else, 42]], empty_table) == 42
  end

  test "cond_action returns the answer for a true question" do
    assert cond_action([:cond, [true, :y]], some_table) == 2
  end

  test "cond_action will iterate until it finds a true question" do
    assert cond_action(
      [:cond, [false, 1], [false, 2], [true, :foo], [false, 4]], some_table
    ) == 99
  end

  test "cond_action will raise an error if no true questions are found" do
    assert_raise RuntimeError, "error: no true questions found.", fn ->
      cond_action([:cond, [false, 1], [false, 2], [false, 3]], some_table)
    end
  end

  test "evlis evaluates a list of arguments" do
    assert evlis([:x, 1, :foo, true], some_table) == [1, 1, 99, true]
  end

  test "evlis handles expressions as arguments" do
    assert evlis([:x, [:car, [:quote, [1, 2, 3]]]], some_table) == [1, 1]
  end

  test "apply_primitive" do
    assert apply_primitive(:cons, [1, []]) == [1]
    assert apply_primitive(:car, [[1, 2]]) == 1
    assert apply_primitive(:eq?, [1, 1])
    refute apply_primitive(:eq?, [1, 2])
    assert apply_primitive(:cdr, [[1,2,3]]) == [2,3]
    assert apply_primitive(:null?, [[]])
    refute apply_primitive(:null?, [[1]])
    assert apply_primitive(:atom?, [1])
    assert apply_primitive(:atom?, [:atom])
    refute apply_primitive(:atom?, [[]])
    assert apply_primitive(:zero?, [0])
    refute apply_primitive(:zero?, [1])
    assert apply_primitive(:add1, [1]) == 2
    assert apply_primitive(:sub1, [2]) == 1
    assert apply_primitive(:number?, [1])
    refute apply_primitive(:number?, [:atom])
    assert apply_primitive(:*, [2, 3]) == 6
  end

  test "apply_primitive raises an error if it cannot match the primitive" do
    assert_raise RuntimeError, "error: no primitive matches foo", fn ->
      apply_primitive(:foo, 42)
    end
  end

  test "appli for primitives" do
    assert appli([:primitive, :car], [[1,2,3]]) == 1
    assert appli([:primitive, :cdr], [[1,2,3]]) == [2,3]
  end

  test "application_action (simple)" do
    assert meaning(:car, empty_table) == [:primitive, :car]
    assert evlis([[:quote, [:a, :b, :c]]], empty_table) == [[:a, :b, :c]]
    assert appli([:primitive, :car], [[:a, :b, :c]]) == :a
    assert application_action([:car, [:quote, [:x, :y, :z]]], some_table) == :x
  end

  test "apply_closure" do
    assert apply_closure([some_table, [:x], [:add1, :x]], [99]) == 100
  end

  test "appli for non-primitives" do
    assert appli([:non_primitive, [some_table, [:x], [:add1, :x]]], [99]) == 100
  end

  test "value" do
    assert value([:car, [:quote, [1, 2, 3]]]) == 1
    assert value([:add1, 2]) == 3
    assert value([:add1, [:add1, 2]]) == 4
  end

  test "value for non-primitives" do
    assert application_action([[:lambda, [:x], [:add1, :x]], 42], empty_table) == 43
  end

  test "value with cond" do
    assert value([
      [:lambda, [:x],
        [:cond,
          [[:eq?, :x, 97], 1],
          [[:eq?, :x, 98], 2],
          [:else, 100]]], 99]) == 100
  end

  test "value with Y" do
    assert value([:eq?, 2, 3]) == false
    assert value([:*, 2, 3]) == 6

    assert value(
     [[[:lambda, [:h], [:h, :h]],
        [:lambda, [:f],
           [:lambda, [:n],
             [:cond, 
               [[:zero?, :n], 1],
               [:else, 
                 [:*, :n, [[:f, :f], [:sub1, :n]]]]]]]], 10]) == 3628800
  end

  defp empty_table, do: [ [[], []] ]
  defp some_table, do: [ [[:x, :y], [1, 2]], [[:bar, :foo], [42, 99]] ]
end
