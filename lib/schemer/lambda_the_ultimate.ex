defmodule Schemer.LambdaTheUltimate do
  @moduledoc """
  @wip p. 147

  atom-to-function
  multiremberT
  multirember&co
  multiinsertLR
  multiinsertLR&co
  evens-only*
  evens-only&co
  """

  @doc """
  (define rember-f
    (lambda (test? a l)
     (cond
       ((null? l) '())
       ((test? (car l) a)
        (cdr l))
       (else
         (cons (car l)
           (rember-f test? a (cdr l)))))))

  (rember-f = 5 '(6 2 5 3))
  => (6 2 3)

  (rember-f eq? 'jelly '(jelly beans are good))
  => (beans are good)

  (rember-f equal? '(pop corn) '(lemonade (pop corn) and (cake)))
  => (lemonde and (cake))
  """
  def rember_f(_, _, []), do: []
  def rember_f(f, a, [h|t]) do
    case f.(a, h) do
      true  -> t
      false -> [h | rember_f(f, a, t)]
    end
  end

  @doc """
  (define eq?-c
    (lambda (a)
      (lambda (x)
        (eq? x a))))

  (define eq?-salad (eq?-c 'salad))
  """
  def eq_c(a), do: fn (x) -> a == x end

  def eq_salad, do: eq_c(:salad)

  @doc """
  (define rember-f-curry
    (lambda (test?)
      (lambda (a l)
        (cond
          ((null? l) '())
          ((test? (car l) a)
            (cdr l))
          (else
            (cons (car l)
              ((rember-f-curry test?) a (cdr l))))))))
  """
  def rember_f_curry(test_fn) do
    fn (_, [])    -> []
       (a, [h|t]) ->
         case test_fn.(a, h) do
           true  -> t
           false -> [h | rember_f_curry(test_fn).(a, t)]
         end
    end
  end

  @doc """
  (define insertL-f
    (lambda (test?)
      (lambda (n o l)
        (cond
          ((null? l) '())
          ((test? (car l) o)
           (cons n l))
          (else
            (cons (car l)
              ((insertL-f test?) n o (cdr l))))))))

  ((insertL-f eq?) 'a 'c '(c d c))
  => (a c d c)
  """
  def insertL_f(test_fn) do
    fn (_, _, []) -> []
       (n, o, [h|t] = l) ->
         case test_fn.(o, h) do
           true  -> [n | l]
           false -> [h | insertL_f(test_fn).(n, o, t)]
         end
    end
  end

  @doc """
  (define insertR-f
    (lambda (test?)
      (lambda (n o l)
        (cond
          ((null? l) '())
          ((test? (car l) o)
           (cons o (cons n (cdr l))))
          (else
            (cons (car l)
                  ((insertR-f test?) n o (cdr l))))))))

  ((insertR-f eq?) 'c 'a '(a d c))
  => (a c d c)
  """
  def insertR_f(test_fn) do
    fn (_, _, []) -> []
       (n, o, [h|t]) ->
         case test_fn.(o, h) do
           true  -> [o | [n | t]]
           false -> [h | insertR_f(test_fn).(n, o, t)]
         end
    end
  end

  @doc """
  (define seqL
    (lambda (n o l)
      (cons n l)))

  (define seqR
    (lambda (n o l)
      (cons o (cons n (cdr l)))))

  (define insert-g
    (lambda (insert-strategy)
      (lambda (n o l)
        (cond
          ((null? l) '())
          ((eq? (car l) o)
           (insert-strategy n o l))
          (else
            (cons (car l)
              ((insert-g insert-strategy) n o (cdr l))))))))

  ((insert-g seqR) 'c 'a '(a d c))
  ((insert-g seqL) 'a 'c '(c d c))
  """
  def seqL(n, _, l), do: [n | l]
  def seqR(n, o, [_|t]), do: [o | [n | t]]

  def insert_g(insert_strategy) do
    fn (_, _, [])        -> []
       (n, o, [o|_] = l) -> insert_strategy.(n, o, l)
       (n, o, [h|t])     -> [h | insert_g(insert_strategy).(n, o, t)]
    end
  end

end
