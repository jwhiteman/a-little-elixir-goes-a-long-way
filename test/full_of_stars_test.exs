defmodule FullOfStarsTest do
  use ExUnit.Case

  import Schemer.FullOfStars

  test "remberS" do
    assert remberS(:cup, [[:coffee], :cup, [[:tea], :cup], [:and, [:hick]], :cup]) ==
      [[:coffee], [[:tea]], [:and, [:hick]]]
  end
end
