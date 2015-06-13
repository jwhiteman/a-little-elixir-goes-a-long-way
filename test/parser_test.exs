defmodule ParserTest do
  use ExUnit.Case

  import Schemer.Support.Parser

  test "an empty list" do
    assert parse("()") == []
  end

  test "a list" do
    assert parse("(+ 1 2 3)") == [:+, 1, 2, 3]
  end

  test "a complex list" do
    assert parse("""
    (define rember
      (lambda (a lat)
        (cond
          ((null? l) (quote ()))
          ((eq? (car lat) a)
           (cdr lat))
          (else
            (cons (car lat)
              (rember a (cdr lat)))))))
    """) == [:define, :rember,
              [:lambda, [:a, :lat],
                [:cond,
                  [[:null?, :l], [:quote, []]],
                  [[:eq?, [:car, :lat], :a],
                    [:cdr, :lat]],
                  [:else,
                    [:cons, [:car, :lat],
                      [:rember, :a, [:cdr, :lat]]]]]]]
  end
end
