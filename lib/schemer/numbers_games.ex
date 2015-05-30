defmodule Schemer.NumbersGames do
  @moduledoc """
  The First Commandment: When recurring on a list
  of atoms, _lat_, ask two questions about it: `(null? lat)`
  and `else`;
  When recurring on a number, _n_, ask two questions about it:
  `(zero? n)` and `else`.

  The Fourth Commandment: Always change at least one argument
  while recurring. It must be changed closer to termination. The
  changing argument must be tested in the termination condition:
  when using cdr, test termination with null? and when using sub1,
  test termination with zero?

  The Fifth Commandment: When building a value with +, always use 0
  for the value of the terminating line, for adding 0 does not change
  the value of an addition.

  When building a value with *, always use 1 for the value of the terminating
  line, for multiplying by 1 does not change the value of a multiplication.

  When building a value with cons, always consider '() for the value of the
  terminating line.
  """

  @doc """
  (define +
    (lambda (n m)
      (cond
        ((zero? n) m)
        (else
          (add1 (+ (sub1 n) m))))))

  (+ 46 12)
  => 58
  """
  def add(0, m), do: m
  def add(n, m), do: 1 + add(n-1, m)

  @doc """
  (define -
    (lambda (n m)
      (cond
        ((zero? m) n)
        (else
          (sub1 (- n (sub1 m)))))))

  (- 14 3)
  => 11

  (- 17 9)
  => 8

  (- 18 25)
  => No answer. Ignore negative numbers for now.
  """
  def sub(n, 0), do: n
  def sub(n, m), do: sub(n, m-1) - 1

  @doc """
  (define addtup
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (+ (car l) (addtup (cdr l)))))))

  (addtup '(3 5 2 8)
  => 18

  (addtup '(15 6 7 12 3))
  => 43

  (addtup '())
  => 0
  """
  def addtup([]), do: 0
  def addtup([h|t]), do: h + addtup(t)

  @doc """
  (define *
    (lambda (n m)
      (cond
        ((eq? 1 m) n)
        (else
          (+ n (* n (sub1 m)))))))

  (* 5 3)
  => 15

  (* 13 4)
  => 52
  """
  def times(n, 1), do: n
  def times(n, m), do: n + times(n, m-1)

  @doc """
  (define tup+
    (lambda (t1 t2)
      (cond
        ((and (null? t1)
              (null? t2))
              '())
        ((null? t1) t2)
        ((null? t2) t1)
        (else
          (cons (+ (car t1) (car t2))
            (tup+ (cdr t1) (cdr t2)))))))

  (tup+ '(3 6 9 11 4) '(8 5 2 0 7))
  => (11 11 11 11 11)

  (tup+ '(2 3) '(4 6))
  => (6 9)

  (tup+ '(3 7) '(4 6 8 1))
  => (7 13 8 1)
  """
  def addtup([], []), do: []
  def addtup(t1, []), do: t1
  def addtup([], t2), do: t2
  def addtup([h1|t1], [h2|t2]), do: [h1 + h2 | addtup(t1, t2)]

  @doc """
  (define >
    (lambda (n m)
      (cond
        ((zero? n) #f)
        ((zero? m) #t)
        (else
          (> (sub1 n) (sub1 m))))))

  (> 12 133)
  => #f

  (> 120 11)
  => #t
  """
  def greater_than(0, 0), do: false
  def greater_than(_, 0), do: true
  def greater_than(0, _), do: false
  def greater_than(n, m), do: greater_than(n-1, m-1)


  @doc """
  (define <
    (lambda (n m)
      (cond
        ((zero? n) #t)
        ((zero? m) #f)
        (else
          (< (sub1 n) (sub1 m))))))
  """
  def less_than(0, 0), do: false
  def less_than(_, 0), do: false
  def less_than(0, _), do: true
  def less_than(n, m), do: less_than(n-1, m-1)

  @doc """
  (define =
    (lambda (n m)
      (cond
        ((and (zero? n)
              (zero? m))
              #t)
        ((or (zero? n)
             (zero? m))
              #f)
        (else
          (= (sub1 n) (sub1 m))))))

  (= 2 3)
  => #2

  (= 9 9)
  => #f
  """
  def equals(0, 0), do: true
  def equals(_, 0), do: false
  def equals(0, _), do: false
  def equals(n, m), do: equals(n-1, m-1)

  @doc """
  (define ^
    (lambda (n m)
      (cond
        ((eq? 1) m) n)
        (else
          (* n (^ n (sub1 m))))))

  (^ 1 1)
  => 1

  (^ 2 3)
  => 8

  (^ 5 3)
  => 125
  """
  def power(n, 1), do: n
  def power(n, m), do: n * power(n, m-1)

  @doc """
  (define div
    (lambda (n m)
      (cond
        ((< n m) 0)
        (else
          (add1 (div (- n m) m))))))
  """
  def divide(n, m) when n < m, do: 0
  def divide(n, m), do: 1 + divide(n-m, m)

  @doc """
  (define length
    (lambda (l)
      (cond
        ((null? l) 0)
        (else
          (add1 (length (cdr l)))))))

  (length '(hotdogs with mustard sauerkraut and pickles))
  => 6

  (length '(ham and cheese on rye))
  => 5
  """
  def size([]), do: 0
  def size([_|t]), do: 1 + size(t)

  @doc """
  (define pick
    (lambda (n l)
      (cond
        ((eq? 1 n) (car l))
        (else
          (pick (sub1 n) (cdr l))))))

  (pick 4 '(lasagna spaghetti ravioli macaroni meatball))
  => macaroni
  """
  def pick(1, [h|_]), do: h
  def pick(n, [_|t]), do: pick(n-1, t)

  @doc """
  (define rempick
    (lambda (n l)
      (cond
        ((eq? 1 n) (cdr l))
        (else
          (cons (car l)
            (rempick (sub1 n) (cdr l)))))))

  (rempick 3 '(hotdogs with hot mustard))
  => (hotdogs with mustard)
  """
  def rempick(1, [_|t]), do: t
  def rempick(n, [h|t]), do: [h | rempick(n-1, t)]

  @doc """
  (define no-nums
    (lambda (l)
      (cond
        ((null? l) '())
        ((number? (car l))
          (no-nums (cdr l)))
        (else
          (cons (car l)
            (no-nums (cdr l)))))))

  (no-nums '(5 pears 6 prunes 9 dates))
  => (pears prunes dates)
  """
  def nonums([]), do: []
  def nonums([h|t]) when is_number(h), do: nonums(t)
  def nonums([h|t]), do: [h | nonums(t)]

  @doc """
   (define allnums
     (lambda (l)
       (cond
         ((null? l) '())
         ((number (car l))
          (cons (car l)
                (allnums (cdr l))))
         (else
           (allnums (cdr l))))))
   (allnums '(5 pears 6 prunes 9 dates))
   => (5 6 9)
  """
  def allnums([]), do: []
  def allnums([h|t]) when is_number(h), do: [h | allnums(t)]
  def allnums([_|t]), do: allnums(t)

  @doc """
  (define equan?
    (lambda (a b)
      (cond
        ((and (number? a) (number? b))
         (= a b))
        ((or (number? a) (number? b))
         (#f))
        (else
          (eq? a b)))))

  (equan? 'a 'b)
  => #f

  (equan? 'z 'z)
  => #t
  """
  def equan(a, a), do: true
  def equan(_, _), do: false

  @doc """
  (define occur
    (lambda (e l)
      (cond
        ((null? l) 0)
        ((eq? (car l) e)
         (add1 (occur e (cdr l))))
        (else
          (occur e (cdr l))))))

  (occur 'c '(a c d c))
  => 2

  (occur 'c '(z z top))
  => 0
  """
  def occur(_, []), do: 0
  def occur(e, [e|t]), do: 1 + occur(e, t)
  def occur(e, [_|t]), do: occur(e, t)

  """
  (define one?
    (lambda (n)
      (= n 1)))

  (one? 1)
  => #t

  (one? 9)
  => #f
  """
  def one(1), do: true
  def one(_), do: false

end
