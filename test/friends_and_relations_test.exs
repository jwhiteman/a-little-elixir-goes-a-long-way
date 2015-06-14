defmodule FriendsAndRelationsTest do
  use ExUnit.Case

  import Schemer.FriendsAndRelations

  test "is_set" do
    refute is_set [:apple, :peaches, :apple, :plum]
    assert is_set [:apple, :peaches, :pears, :plums]
    assert is_set []
  end

  test "makeset" do
    assert makeset([:apple, :peach, :pear, :peach, :plum, :apple, :lemon, :peach]) ==
      [:pear, :plum, :apple, :lemon, :peach]
  end
end
