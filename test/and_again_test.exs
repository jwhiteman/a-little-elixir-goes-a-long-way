defmodule AndAgainTest do
  use ExUnit.Case

  import Schemer.AndAgain

  test "looking" do
    assert looking(:caviar, [6, 2, 4, :caviar, 5, 7, 3])
    refute looking(:caviar, [6, 2, :grits, :caviar, 5, 7, 3])
  end
end
