defmodule DoItAgainTest do
  use ExUnit.Case

  import Schemer.DoItAgain

  test "lat" do
    assert lat([:jack, :sprat, :could, :eat, :no, :fat])
    refute lat([[:jack], :sprat, :could, :eat, :no, :fat])
    assert lat([])
  end

  test "member" do
    refute member(:poached, [:fried, :eggs, :and, :scrambled, :eggs])
    assert member(:meat, [:mashed, :potatoes, :and, :meat, :gravy])
  end
end
