defmodule ToysTest do
  use ExUnit.Case

  import Schemer.Toys

  test "car" do
    assert car([1, 2, 3]) == 1
  end

  test "cdr" do
    assert cdr([1, 2, 3]) == [2, 3]
  end

  test "cons" do
    assert cons(1, [2, 3]) == [1, 2, 3]
  end

  test "null?" do
    assert null?([])
    refute null?([1])
  end

  test "eq?" do
    assert eq?(:a, :a)
    refute eq?(:a, :b)
  end
end
