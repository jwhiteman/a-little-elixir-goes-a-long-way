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
    lookup_in_table(e, table, fn (n) -> raise "identifier #{n} not found." end)
  end

  @doc """
  (define *lambda
    (lambda (e table)
      (build 'non-primitive
         (cons table (cdr e)))))
  """
  def lambda_action([_type, formals, body], table) do
    [:non_primitive, [table, formals, body]]
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
  def list_to_action([:quote|_]), do: &Schemer.WhatIsTheValueOfAllOfThis.quote_action/2
  def list_to_action([:lambda|_]), do: &Schemer.WhatIsTheValueOfAllOfThis.lambda_action/2
  def list_to_action([:cond|_]), do: &Schemer.WhatIsTheValueOfAllOfThis.cond_action/2
  def list_to_action(_) do
    &Schemer.WhatIsTheValueOfAllOfThis.application_action/2
  end

  @doc """
  (define expression-to-action
    (lambda (e)
      (cond
        ((atom? e) (atom-to-action e))
        (else
          (list-to-action e)))))
  """
  def expression_to_action(e = [_|_]), do: list_to_action(e)
  def expression_to_action(e) do
    atom_to_action(e)
  end

  @doc """
  (define meaning
    (lambda (e table)
      ((expression-to-action e) e table)))
  """
  def meaning(e, table) do
    expression_to_action(e).(e, table)
  end

  @doc """
  (define evcon
    (lambda (lines table)
      (cond
        ((else? (question-of (car lines)))
         (meaning (answer-of (car lines)) table))
        ((meaning (question-of (car lines)) table)
         (meaning (answer-of (car lines)) table))
        (else
          (evcon (cdr lines) table)))))

  (define else?
    (lambda (x)
      (cond
        ((atom? x) (eq? x 'else))
        (else #f))))

  (define question-of first)
  (define answer-of second)
  (define cond-lines-of cdr)

  (define *cond
    (lambda (e table)
      (evcon (cond-lines-of e) table)))
  """
  def cond_action([_ | cond_lines], table), do: evcon(cond_lines, table)

  defp evcon([[:else, answer]], table), do: meaning(answer, table)

  defp evcon([[question, answer] | remaining_questions], table) do
    case meaning(question, table) do
      true  -> meaning(answer, table)
      false -> evcon(remaining_questions, table)
    end
  end
  defp evcon([], _), do: raise "error: no true questions found."

  @doc """
  (define evlis
    (lambda (args table)
      (cond
        ((null? args) '())
        (else
          (cons (meaning (car args) table)
             (evlis (cdr args) table))))))
  """
  def evlis([], _), do: []
  def evlis([h|t], table) do
    [meaning(h, table) | evlis(t, table)]
  end

  @doc """
  (define apply-primitive
    (lambda (name vals)
      (cond
        ((eq? name 'cons)
         (cons (first vals) (second vals)))
        ((eq? name 'car)
         (car (first vals)))
        ((eq? name 'cdr)
         (cdr (first vals)))
        ((eq? name 'null?)
         (null? (first vals)))
        ((eq? name 'eq?)
         (eq? (first vals) (second vals)))
        ((eq? name 'atom?)
         (:atom? (first vals)))
        ((eq? name 'zero?)
         (zero? (first vals)))
        ((eq? name 'add1)
         (+ 1 (first vals)))
        ((eq? name 'sub1)
         (- 1 (first vals)))
        ((eq? name 'number?)
         (number? (first vals))))))
  """
  def apply_primitive(:eq?, [v, v]), do: true
  def apply_primitive(:eq?, [_, _]), do: false
  def apply_primitive(:cons, [l, r]), do: [l|r]
  def apply_primitive(:car, [[h|_] | _]), do: h
  def apply_primitive(:cdr, [[_|t] | _]), do: t
  def apply_primitive(:null?, [[] | _]), do: true
  def apply_primitive(:null?, _), do: false
  def apply_primitive(:atom?, [n]), do: is_atom(n) || is_number(n)
  def apply_primitive(:zero?, [0]), do: true
  def apply_primitive(:zero?, _), do: false
  def apply_primitive(:add1, [n]) do
    n + 1
  end
  def apply_primitive(:sub1, [n]), do: n - 1
  def apply_primitive(:number?, [n]), do: is_number(n)
  def apply_primitive(:*, [l, r]), do: l * r
  def apply_primitive(n, _), do: raise "error: no primitive matches #{n}"

  @doc """
  (define apply
    (lambda (fun vals)
      (cond
        ((primitive? fun)
         (apply-primitive (second fun) vals))
        ((non-primitive? fun)
         (apply-closure (second fun) vals)))))
  """
  def appli([:primitive, fun_rep], vals) do
    apply_primitive(fun_rep, vals)
  end

  def appli([:non_primitive, fun_rep], vals) do
    apply_closure(fun_rep, vals)
  end

  @doc """
  (define *application
    (lambda (e table)
      (applyz
        (meaning (function-of e) table)
        (evlis (arguments-of e) table))))
  """
  def application_action([func | args], table) do
    f = meaning(func, table)
    a = evlis(args, table)

    appli(
      f,
      a
    )
  end

  @doc """
  (define apply-closure
    (lambda (closure vals)
      (meaning
        (body-of closure)
        (extend-table
           (new-entry (formals-of closure) vals)
               (table-of closure)))))
  """
  def apply_closure([table, formals, body], vals) do
    meaning(body, [[formals, vals] | table])
  end

  @doc """
  (define value
    (lambda (e)
        (meaning e '())))
  """
  def value(e), do: meaning(e, [])

  defp primitives do
    [
      true, false, :cons,
      :car, :cdr, :null?,
      :eq?, :atom?, :zero?,
      :add1, :sub1, :number?,
      :*
    ]
  end

  defp is_member(_, []), do: false
  defp is_member(a, [a|_]), do: true
  defp is_member(a, [_|t]), do: is_member(a, t)

end
