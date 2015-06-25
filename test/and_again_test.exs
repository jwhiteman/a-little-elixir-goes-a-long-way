defmodule AndAgainTest do
  use ExUnit.Case

  import Schemer.AndAgain

  test "looking" do
    assert looking(:caviar, [6, 2, 4, :caviar, 5, 7, 3])
    refute looking(:caviar, [6, 2, :grits, :caviar, 5, 7, 3])
  end

  test "shift" do
    assert shift([[1, 2], 3]) == [1, [2, 3]]
    assert shift([[1, 2], [3, 4]]) == [1, [2, [3, 4]]]
  end

  test "Y" do
    assert y(
      fn (m) ->
        fn (0) -> 1
           (n) -> n * m.(n - 1)
        end
      end
    ).(10) == 3628800
  end
end
