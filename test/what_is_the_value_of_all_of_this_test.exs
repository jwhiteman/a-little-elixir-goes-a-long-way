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
      [:non_primitive, empty_table, [:x], [:add1, :x]]
  end

  test "a lambda stores its environment" do
    [_, table, _, _] = lambda_action([:lambda, [:x], [:add1, :x]], some_table)

    assert table == some_table
  end

  test "atom_to_action returns const_action for nums, bools, and build-in methods" do
    assert atom_to_action(1)      == &const_action/2
    assert atom_to_action(true)   == &const_action/2
    assert atom_to_action(:car)   == &const_action/2
  end

  test "atom_to_action returns identifier_action for everything else" do
    assert atom_to_action(:foo) == &identifier_action/2
  end

  test "list_to_action returns quote, lambda, cond, and application actions" do
    #  assert list_to_action([:quote, []]) == &quote_action/2
    #  assert list_to_action([:lambda, [], []]) == &lambda_action/2
    #  assert list_to_action([:cond, [:else, 42]]) == &cond_action/2
    #  assert list_to_action([
    #    [:lambda, [:x], [:add1, :x]],
    #    42
    #  ]) == &application_action/2
  end

  defp empty_table, do: [ [[], []] ]
  defp some_table, do: [ [[:x, :y], [1, 2]], [[:bar, :foo], [42, 99]] ]
end
