defmodule DoItAgainTest do
  use ExUnit.Case

  import Schemer.DoItAgain

  test "lat" do
    assert lat([:jack, :sprat, :could, :eat, :no, :fat]) == true
    assert lat([[:jack], :sprat, :could, :eat, :no, :fat]) == false
    assert lat([]) == true
  end

  test "member" do
    assert member(:poached, [:fried, :eggs, :and, :scrambled, :eggs]) == false
    assert member(:meat, [:mashed, :potatoes, :and, :meat, :gravy]) == true
  end
end
