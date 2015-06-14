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
end
