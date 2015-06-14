# Chapter 7. WIP
defmodule Schemer.FriendsAndRelations do
  import Schemer.DoItAgain, only: [member: 2]

  @moduledoc """
  subset?
  eqset?
  intersect?
  intersect
  union
  intersectall
  a-pair?
  first
  second
  build
  third
  fun?
  revrel
  revpair
  fullfun?
  one-to-one
  """

  @doc """
  (define set?
    (lambda (lat)
      (cond
        ((null? lat) #t)
        ((member? (car lat) (cdr lat)) #f)
        (else
          (set? (cdr lat))))))

  (set? (quote (apple peaches apple plum)))
  => #f

  (set? (quote (apple peaches pears plums)))
  => #t

  (set? (quote (quote ())))
  => #t
  """
  def is_set([]), do: true
  def is_set([h|t]) do
    case member(h, t) do
      true  -> false
      false -> is_set(t)
    end
  end

  @doc """
  (define makeset
    (lambda (lat)
      (cond
        ((null? lat) '())
        ((member? (car lat) (cdr lat))
         (makeset (cdr lat)))
        (else
          (cons (car lat) (makset (cdr lat)))))))

  (makeset '(apple peach pear peach plum apple lemon peach))
  => (pear plum apple lemon peach)
  """
  def makeset([]), do: []
  def makeset([h|t]) do
    case member(h, t) do
      true  -> makeset(t)
      false -> [h | makeset(t)]
    end
  end
end
