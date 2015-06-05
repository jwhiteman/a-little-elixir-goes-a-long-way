defmodule Schemer.DoItAgain do
  @moduledoc """
  The First Commandment (preliminary): Always ask _null?_ as the first question in
  expressing any function.
  """

  @doc """
  (define lat?
    (lambda (l)
      (cond
        ((null? l) #t)
        (else
          (and (atom? (car l))
               (lat? (cdr l)))))))


  (lat? '(jack sprat could eat no fat))
  => #t

  (lat? '((jack sprat could eat no fat)))
  => #f

  (lat? '())
  => #f
  """
  def lat([]), do: true
  def lat([[_|_]|_]), do: false
  def lat([_|t]), do: lat(t)

  @doc """
  (define member?
    (lambda (a lat)
      (cond
        ((null? lat) #f)
        ((eq? (car lat) a) #t)
        (else
          (member? a (cdr lat))))))

  (member? 'poached '(fried eggs and scrambled eggs))
  => #f

  (member? 'meat '(mashed potatoes and meat gravy))
  => #t
  """
  def member(_, []), do: false
  def member(a, [a|_]), do: true
  def member(a, [_|t]), do: member(a, t)

end
