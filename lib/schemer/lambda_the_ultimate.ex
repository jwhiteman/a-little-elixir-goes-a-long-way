# Chapter 8.
defmodule Schemer.LambdaTheUltimate do
  import Schemer.Shadows, only: [
    operator_for: 1,
    first_sub_expression: 1,
    second_sub_expression: 1
  ]

  import Schemer.FullOfStars, only: [equal: 2]

  @moduledoc """
  The Ninth Commandment: Abstract common patterns with a new function.

  The Tenth Commandment: Build functions to collect more than one value at a time.
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
      (cons n (cons o l))))

  (define seqR
    (lambda (n o l)
      (cons o (cons n l))))

  (define insert-g
    (lambda (insert-strategy)
      (lambda (n o l)
        (cond
          ((null? l) '())
          ((eq? (car l) o)
           (insert-strategy n o (cdr l)))
          (else
            (cons (car l)
              ((insert-g insert-strategy) n o (cdr l))))))))

  ((insert-g seqR) 'c 'a '(a d c))
  ((insert-g seqL) 'a 'c '(c d c))
  """
  def seqL(n, o, l), do: [n | [o | l]]
  def seqR(n, o, l), do: [o | [n | l]]

  def insert_g(insert_strategy) do
    fn (_, _, [])    -> []
       (n, o, [o|t]) -> insert_strategy.(n, o, t)
       (n, o, [h|t]) -> [h | insert_g(insert_strategy).(n, o, t)]
    end
  end

  @doc """
  (define seqS (lambda (n o l) (cons n l)))
  (define subst (insert-g seqS))

  (subst 'elixir 'erlang '(my other erlang is an elixir))
  => (my other elixir is an erlang)
  """
  def seqS(n, _, l), do: [n | l]
  def subst(n, o, l), do: insert_g(&seqS/3).(n, o, l)

  @doc """
  (define seqrem (lambda (n o l) l))

  (define rember
    (lambda (n l)
      ((insert-g seqrem) #f n l))))

  (rember 'worm '(apple apple worm apple))
  => '(apple apple apple)
  """
  def seqrem(_, _, l), do: l
  def rember(a, l), do: insert_g(&seqrem/3).(nil, a, l)

  @doc """
  (define atom-to-function
    (lambda (x)
      (cond
        ((eq? x '*) *)
        ((eq? x '+) +)
         (else ^))))

  (define value
    (lambda (nexp)
      (cond
        ((atom? nexp) nexp)
        (else
          ((atom-to-function (operator nexp))
           (value (1st-sub-expression nexp))
           (value (2nd-sub-expression nexp)))))))

  (value '(1 + (3 * 4)))
  => 13
  """
  def atom_to_function(:+), do: &add/2
  def atom_to_function(:*), do: &times/2
  def atom_to_function(:^), do: &pow/2

  def value([_|_]=nexp) do
    atom_to_function(operator_for(nexp)).(
      value(first_sub_expression(nexp)),
      value(second_sub_expression(nexp))
    )
  end
  def value(nexp), do: nexp

  defp pow(_, 0), do: 1
  defp pow(n, m), do: n * pow(n, m-1)

  defp add(n, m), do: n + m

  defp times(n, m), do: n * m

  @doc """
  (define multirember-f
    (lambda (test?)
      (lambda (a l)
        (cond
          ((null? l) (quote ()))
          ((test? (car l) a)
           ((multirember-f test?) a (cdr l)))
          (else
            (cons (car l)
              ((multirember-f test?) a (cdr l))))))))

  ((multirember-f eq?) (quote c) (quote (a c d c)))
  => (a d)
  """
  def multirember_f(test) do
    fn (_, [])    -> []
       (a, [h|t]) ->
         case test.(a, h) do
           true   -> multirember_f(test).(a, t)
           false  -> [h | multirember_f(test).(a, t)]
         end
    end
  end

  @doc """
  (define multirember-eq? (multirember-f eq?))
  """
  def multirember_eq, do: multirember_f(&equal/2)

  @doc """
  (define eq?-tuna
    (eq?-c (quote tuna)))

  (define multiremberT
    (lambda (test)
      (lambda (l)
        (cond
          ((null? l) (quote ()))
          ((test (car l))
            ((multiremberT test) (cdr l)))
          (else
            (cons (car l)
              ((multiremberT test) (cdr l))))))))

  ((multiremberT eq?-tuna) (quote (shrimp salad tuna salad and tuna)))
  => (shrimp salad salad and)
  """
  def eq_tuna, do: eq_c(:tuna)

  def multiremberT(test) do
    fn ([])    -> []
       ([h|t]) ->
         case test.(h) do
           true  -> multiremberT(test).(t)
           false -> [h | multiremberT(test).(t)]
         end
    end
  end

  @doc """
  multirember&co looks at every atom of the _lat_ to see
  whether it is _eq?_ to _a_. Those atoms that are not are
  collected in one list _newlat_; the others for which the
  answer is true are collected in a second list _seen_. Finally,
  it determines the value of (col newlat seen).

  (define multirember&co
    (lambda (a lat col)
      (cond
        ((null? lat) (col (quote ()) (quote ())))
        ((eq? (car lat) a)
         (multirember&co a (cdr lat)
           (lambda (newlat seen)
             (col newlat (cons (car lat) seen)))))
        (else
          (multirember&co a (cdr lat)
            (lambda (newlat seen)
             (col (cons (car lat) newlat) seen)))))))

  (multirember&co 'a '(x y z a b a a a c) (lambda (x y) (cons x (cons y (quote ())))))
  => ((x y z b c) (a a a a))
  """
  def multirember_and_co(_, [], col), do: col.([], [])
  def multirember_and_co(a, [a|t], col) do
    multirember_and_co(a, t, &( col.(&1, [a|&2]) ))
  end
  def multirember_and_co(a, [h|t], col) do
    multirember_and_co(a, t, &( col.([h|&1], &2)))
  end

  @doc """
  (define multiinsertLR
    (lambda (new oldL oldR lat)
      (cond
        ((null? lat) (quote ()))
        ((eq? (car lat) oldL)
         (cons new (cons oldL (multiinsertLR new oldL oldR (cdr lat)))))
        ((eq? (car lat) oldR)
         (cons oldR (cons new (multiinsertLR new oldL oldR (cdr lat)))))
        (else
          (cons (car lat)
            (multiinsertLR new oldL oldR (cdr lat)))))))

  (multiinsertLR 'zap 'l 'r '(l x r x))
  => (zap l x r zap x)
  """
  def multiinsertLR(_, _, _, []), do: []
  def multiinsertLR(n, oldl, oldr, [oldl|t]) do
    [n | [oldl | multiinsertLR(n, oldl, oldr, t)]]
  end
  def multiinsertLR(n, oldl, oldr, [oldr|t]) do
    [oldr | [n | multiinsertLR(n, oldl, oldr, t)]]
  end
  def multiinsertLR(n, oldl, oldr, [h|t]) do
    [h | multiinsertLR(n, oldl, oldr, t)]
  end

  @doc """
  (define multiinsertLR&co
    (lambda (new oldL oldR lat col)
      (cond
        ((null? lat) (col 0 0))
        ((eq? (car lat) oldL)
         (multiinsertLR&co new oldL oldR (cdr lat)
           (lambda (left right)
             (col (add1 left) right))))
        ((eq? (car lat) oldR)
         (multiinsertLR&co new oldL oldR (cdr lat)
           (lambda (left right)
             (col left (add1 right)))))
        (else
          (multiinsertLR&co new oldL oldR (cdr lat) col)))))

  (multiinsertLR&co 'zap 'l 'r '(l x r x r l r)
     (lambda (lc rc) (cons lc (cons rc (quote ())))))
  => (2 3)
  """
  def multiinsertLR_and_co(_, _, _, [], col) do
    col.(0, 0)
  end

  def multiinsertLR_and_co(new, oldL, oldR, [oldL|t], col) do
    multiinsertLR_and_co(
      new, oldL, oldR, t,
      fn (left, right) -> col.(left + 1, right) end
    )
  end
  def multiinsertLR_and_co(new, oldL, oldR, [oldR|t], col) do
    multiinsertLR_and_co(
      new, oldL, oldR, t,
      fn (left, right) -> col.(left, right + 1) end
    )
  end
  def multiinsertLR_and_co(new, oldL, oldR, [_|t], col) do
    multiinsertLR_and_co(new, oldL, oldR, t, col)
  end

  @doc """
  (define evens-only*
    (lambda (l)
      (cond
        ((null? l) (quote ()))
        ((atom? (car l))
         (cond
           ((even? (car l))(cons (car l) (evens-only* (cdr l))))
           (else
             (evens-only* (cdr l)))))
        (else
          (cons (evens-only* (car l))
                (evens-only* (cdr l)))))))
   (evens-only* (quote ((9 1 2 8) 3 10 ((9 9) 7 6) 2)))
   => ((2 8) 10 (() 6) 2)
  """
  def evens_only_star([]), do: []
  def evens_only_star([h=[_|_]|t]), do: [evens_only_star(h) | evens_only_star(t)]
  def evens_only_star([h|t]) when rem(h,2) == 0, do: [h | evens_only_star(t)]
  def evens_only_star([_|t]), do: evens_only_star(t)

  @doc """
  evens-only*&co builds a nested list of even numbers by removing the odd
  ones from its argument list and simultaneously multiplies the even numbers
  and sums up the odd numbers that occur in its argument.

  (define evens-only*&co
    (lambda (l col)
      (cond
        ((null? l) (col (quote ()) 1 0))
        ((atom? (car l))
         (cond
           ((even? (car l))
            (evens-only*&co (cdr l)
              (lambda (result product sum)
                (col (cons (car l) result)
                     (* (car l) product)
                     sum))))
            (else
              (evens-only*&co (cdr l)
                (lambda (result product sum)
                  (col result product (+ (car l) sum)))))))
        (else
          (evens-only*&co (car l)
            (lambda (car-result car-product car-sum)
              (evens-only*&co (cdr l)
                (lambda (cdr-result cdr-product cdr-sum)
                  (col (cons car-result cdr-result)
                       (* car-product cdr-product)
                       (+ car-sum cdr-sum))))))))))
  (evens-only*&co 
    (quote ((9 1 2 8) 3 10 ((9 9) 7 6) 2))
    (lambda (x y z) (cons x (cons y (cons z (quote ()))))))
  => (((2 8) 10 (() 6) 2) 1920 38)
  """
  def evens_only_star_and_co([], col), do: col.([], 1, 0)
  def evens_only_star_and_co([h=[_|_]|t], col) do
    evens_only_star_and_co(
      h,
      fn (car_result, car_product, car_sum) ->
        evens_only_star_and_co(
          t,
          fn (cdr_result, cdr_product, cdr_sum) ->
            col.([car_result|cdr_result], car_product * cdr_product, car_sum + cdr_sum)
          end)
      end)
  end
  def evens_only_star_and_co([h|t], col) when rem(h,2) == 0 do
    evens_only_star_and_co(t, fn (result, product, sum) ->
      col.([h | result], h * product, sum)
    end)
  end
  def evens_only_star_and_co([h|t], col) do
    evens_only_star_and_co(t, fn (result, product, sum) ->
      col.(result, product, sum + h)
    end)
  end

end
