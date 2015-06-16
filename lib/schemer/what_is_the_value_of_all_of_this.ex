# Chapter 10.
defmodule Schemer.WhatIsTheValueOfAllOfThis do
  import Schemer.FriendsAndRelations, only: [
    build: 2,
    first: 1,
    second: 1
  ]

  @doc """
  ;; helpers
  (define new-entry build)
  (define extend-table cons)
  """
  def new_entry(l, r), do: build(l, r)
  def extend_table(e, table), do: [e | table]

  @doc """
  (define lookup-in-entry
    (lambda (name entry entry-f)
      (lookup-in-entry-help name
        (first entry)
        (second entry)
        entry-f)))

  (define lookup-in-entry-help
    (lambda (target keys values error-function)
      (cond
        ((null? keys) (error-function target))
        ((eq? (car keys) target)
         (car values))
        (else
          (lookup-in-entry-help target
            (cdr keys) (cdr values) error-function)))))

  (lookup-in-entry
    'entree
    '((appetizer entree beverage) (food tastes good))
    (lambda (x) (print "error")))
  => tastes
  """
  def lookup_in_entry(name, [keys, values], error_function) do
    lookup_in_entry_help(name, keys, values, error_function)
  end

  defp lookup_in_entry_help(name, [], _, error_function) do
    error_function.(name)
  end

  defp lookup_in_entry_help(name, [name|_], [value|_], _) do
    value
  end

  defp lookup_in_entry_help(name, [_|keys], [_|values], error_function) do
    lookup_in_entry_help(name, keys, values, error_function)
  end

  @doc """
  (define lookup-in-table
    (lambda (name table table-f)
      (cond
        ((null? table) (table-f name))
        (else
          (lookup-in-entry name
            (car table)
            (lambda (name)
              (lookup-in-table name (cdr table)
                table-f)))))))

  (lookup-in-table 'foo
    '(((foo bar)(42 2))
      ((foo bizz)(7 11))) 
    (lambda (x) (print "error")))
  => 42
  """
  def lookup_in_table(name, [], table_f), do: table_f.(name)
  def lookup_in_table(name, [entry|rest_of_table], table_f) do
    lookup_in_entry(
      name,
      entry,
      fn (n) -> lookup_in_table(n, rest_of_table, table_f) end
    )
  end

  @doc """
  (define *const
    (lambda (e table)
      (cond
        ((number? e) e)
        ((eq? e #t) #t)
        ((eq? e #f) #f)
        (else
          (build 'primitive e)))))
  """
  def const_action(n, _) when is_number(n), do: n
  def const_action(b, _) when is_boolean(b), do: b
  def const_action(p, _), do: [:primitive, p]

  @doc """
  (define *quote
    (lambda (e table)
      (text-of e)))
  """
  def quote_action([_label, body], _), do: body

  @doc """
  (define *identifier
    (lambda (e table)
      (lookup-in-table e table initial-table)))
  """
  def identifier_action(e, table) do
    lookup_in_table(e, table, fn (_) -> raise "error." end)
  end

  @doc """
  (define *lambda
    (lambda (e table)
      (build 'non-primitive
         (cons table (cdr e)))))
  """
  def lambda_action([_type, formals, body], table) do
    [:non_primitive, table, formals, body]
  end

  @doc """
  (define atom-to-action
    (lambda (e)
      (cond
        ((number? e) *const)
        ((eq? e #t) *const)
        ((eq? e #f) *const)
        ((eq? e 'cons) *const)
        ((eq? e 'car) *const)
        ((eq? e 'cdr) *const)
        ((eq? e 'null?) *const)
        ((eq? e 'eq?) *const)
        ((eq? e 'atom?) *const)
        ((eq? e 'zero?) *const)
        ((eq? e 'add1) *const)
        ((eq? e 'sub1) *const)
        ((eq? e 'number?) *const)
        (else *identifier))))
  """
  def atom_to_action(n) when is_number(n) do
    &Schemer.WhatIsTheValueOfAllOfThis.const_action/2
  end

  def atom_to_action(e) do
    case is_member(e, primitives) do
      true  -> &Schemer.WhatIsTheValueOfAllOfThis.const_action/2
      false -> &Schemer.WhatIsTheValueOfAllOfThis.identifier_action/2
    end
  end

  @doc """
  (define list-to-action
    (lambda (e)
      (cond
        ((atom? (car e))
         (cond
           ((eq? (car e) 'quote) *quote)
           ((eq? (car e) 'lambda) *lambda)
           ((eq? (car e) 'cond) *cond)
           (else *application)))
        (else *application))))
  """

  def cond_action(_, _), do: raise "not implemented"
  def application_action(_, _), do: raise "not implemented"

  defp primitives do
    [
      true, false, :cons,
      :car, :cdr, :null?,
      :eq?, :atom?, :zero?,
      :add1, :sub1, :number?
    ]
  end

  defp is_member(_, []), do: false
  defp is_member(a, [a|_]), do: true
  defp is_member(a, [_|t]), do: is_member(a, t)

end
