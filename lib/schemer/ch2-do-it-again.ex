# Chapter 2
defmodule Schemer.DoItAgain do
  # You go back, Jack, do it again...

  @moduledoc """
  The First Commandment (preliminary): Always ask _null?_ as the first question in
  expressing any function.
  """

  @doc """
  (lat? '(jack sprat could eat no fat))
  => #t

  (lat? '((jack sprat could eat no fat)))
  => #f

  (lat? '())
  => #f

  (define lat?
    (lambda (l)
      (cond
        ((null? l) #t)
        (else
          (and (atom? (car l))
               (lat? (cdr l)))))))

  """
  def lat([]), do: true
  def lat([[_|_]|_]), do: false
  def lat([_|t]), do: lat(t)

  @doc """
  (member? 'poached '(fried eggs and scrambled eggs))
  => #f

  (member? 'meat '(mashed potatoes and meat gravy))
  => #t

  (define member?
    (lambda (a lat)
      (cond
        ((null? lat) #f)
        ((eq? (car lat) a) #t)
        (else
          (member? a (cdr lat))))))
  """
  def member(_, []), do: false
  def member(a, [a|_]), do: true
  def member(a, [_|t]), do: member(a, t)

end
