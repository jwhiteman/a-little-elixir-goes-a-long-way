# Chapter 1.
defmodule Schemer.Toys do

  @doc """
  The Law of Car: The primitive _car_ is defined only for non-empty lists.

  (car '(a b c))
  => a

  (car '((a) b c))
  => ((a))

  (car '())
  => undefined/error
  """
  def car([first|_]), do: first

  @doc """
  The Law of Cdr: The primitive _cdr_ is defined only for non-empty lists.
  The _cdr_ of any non-empty list is always another list.

  (cdr '(a b c))
  => (b c)

  (cdr '(a (b c)))
  => ((b c))

  (cdr '())
  => undefined/error
  """
  def cdr([_|rest]), do: rest

  @doc """
  The Law of Cons: The primitive _cons_ takes two arguments. The second argument
  to cons must be a list. The result is a list.

  (cons 'a '(b c))
  => '(a b c)
  """
  def cons(a, l), do: [a | l]

  @doc """
  The Law of Null: The primitive _null?_ is defined only for lists.

  (null? '())
  => #t

  (null? '(a b c))
  => #f
  """
  def null?([]), do: true
  def null?(_), do: false

  @doc """
  The Law of Eq?: The Primitive _eq?_ takes two arguments. Each must be a non-numeric atom.

  (eq? 'a 'a)
  => #t

  (eq? 'a 'b)
  => #f

  (eq? 'a '(a))
  => undefined/error
  """
  def eq?(a, a) when is_atom(a), do: true
  def eq?(a, b) when is_atom(a) and is_atom(b), do: false

end
