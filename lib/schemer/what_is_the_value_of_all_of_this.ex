# Chapter 10. WIP 196
defmodule Schemer.WhatIsTheValueOfAllOfThis do
  import Schemer.FriendsAndRelations, only: [
    build: 2,
    first: 1,
    second: 1
  ]

  @moduledoc """
  [] lookup-in-table
  expression-to-action
  atom-to-action
  list-to-action
  value
  meaning
  *const
  *quote
  *identifier
  initial-table
  *lambda
  table-of
  formals-of
  body-of
  evcon
  else?
  question-of
  answer-of
  *cond
  cond-lines-of
  evlis
  *application
  function-of
  arguments-of
  primitive?
  non-primitive?
  apply
  apply-primitive
  :atom?
  apply-closure
  """

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

end
