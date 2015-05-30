defmodule NumbersGamesTest do
  use ExUnit.Case

  import Schemer.NumbersGames

  test "add" do
    assert add(46, 12) == 58
  end

  test "sub" do
    assert sub(14, 3) == 11
    assert sub(17, 9) == 8
  end

  test "addtup" do
    assert addtup([3, 5, 2, 8]) == 18
    assert addtup([15, 6, 7, 12, 3]) == 43
    assert addtup([3, 7], [4, 6, 8, 1]) == [7, 13, 8, 1]
  end

  test "times" do
    assert times(5, 3) == 15
    assert times(13, 4) == 52
  end

  test "greater_than" do
    assert greater_than(12, 133) == false
    assert greater_than(120, 11) == true
  end

  test "less_than" do
    assert less_than(4, 2) == false
    assert less_than(2, 4) == true
    assert less_than(0, 0) == false
  end

  test "equals" do
    assert equals(2, 3) == false
    assert equals(9, 9) == true
  end

  test "power" do
    assert power(1, 1) == 1
    assert power(2, 3) == 8
    assert power(5, 3) == 125
  end

  test "divide" do
    assert divide(5, 3) == 1
    assert divide(7, 3) == 2
  end

  test "size" do
    assert size([:hotdogs, :with, :mustard, :sauerkraut, :and, :pickes]) == 6
    assert size([:ham, :and, :cheese, :on, :rye]) == 5
  end

  test "pick" do
    assert pick(4, [:lasagna, :spaghetti, :ravioli, :macaroni, :meatball]) == :macaroni
  end

  test "rempick" do
    assert rempick(3, [:hotdogs, :with, :hot, :mustard]) == [:hotdogs, :with, :mustard]
  end

  test "nonums" do
    assert nonums([5, :pears, 6, :prunes, 9, :dates]) == [:pears, :prunes, :dates]
  end

  test "allnums" do
    assert allnums([5, :pears, 6, :prunes, 9, :dates]) == [5, 6, 9]
  end

  test "equan" do
    assert equan(:a, :b) == false
    assert equan(:z, :z) == true
  end

  test "occur" do
    assert occur(:c, [:a, :c, :d, :c]) == 2
    assert occur(:c, [:z, :z, :top]) == 0
  end

  test "one" do
    assert one(1) == true
    assert one(9) == false
  end

end
