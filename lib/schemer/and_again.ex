# Chapter 9. WIP
defmodule Schemer.AndAgain do

  import Schemer.NumbersGames, only: [pick: 2]
  import Schemer.FriendsAndRelations, only: [build: 2, first: 1, second: 1]

  @moduledoc """
  length*
  weight*
  shuffle
  C
  A
  last-try
  Y
  """

  @doc """
  (looking 'caviar '(6 2 4 caviar 5 7 3))
  => #t

  (looking 'caviar '(6 2 grits caviar 5 7 3))
  => #f

  (define looking
    (lambda (a lat)
      (keep-looking a (pick 1 lat) lat)))

  (define keep-looking
    (lambda (a sorn lat)
      (cond
        ((number? sorn)
         (keep-looking a (pick sorn lat) lat))
        (else
          (eq? sorn a)))))
  """
  def looking(a, lat), do: keep_looking(a, pick(1, lat), lat)

  defp keep_looking(a, sorn, lat) when is_number(sorn) do
    keep_looking(a, pick(sorn, lat), lat)
  end
  defp keep_looking(a, a, _), do: true
  defp keep_looking(_, _, _), do: false

  @doc """
  (define eternity
    (lambda (x)
      (eternity x)))
  """
  def eternity(x), do: eternity(x)

  @doc """
  (shift '((a b) c))
  => (a (b c))

  (shift '((a b) (c d)))
  => (a (b (c d)))

  (define shift
    (lambda (pair)
      (build (first (first pair))
        (build (second (first pair))
          (second pair)))))
  """
  def shift([[f1, f2], s2]), do: build(f1, build(f2, s2))

end
