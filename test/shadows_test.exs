defmodule ShadowsTest do
  use ExUnit.Case

  import Schemer.Shadows

  test "numbered" do
    assert numbered([1, :+, 1]) == true
    assert numbered(1) == true
    assert numbered([3, :+, [4, :*, 5]]) == true
    assert numbered([3, :*, :sausage]) == false
  end

  test "value" do
    assert value(13) == 13
    assert value([1, :+, 3]) == 4
    assert value([1, :+, [3, :^, 4]]) == 82
  end

  test "generic_value" do
    assert generic_value(13) == 13
    assert generic_value([1, :+, 3]) == 4
    assert generic_value([1, :+, [3, :^, 4]]) == 82
  end

  test "sadd" do
    assert sero([]) == true
    assert sadd([[], []], [[]]) == [[], [], []]
  end
end
