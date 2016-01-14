# Chapter 3
defmodule Schemer.ConsTheMagnificent do

  @moduledoc """
  The Second Commandment: Use cons to build lists.

  The Third Commandment: When building a list, describe
  the first typical element and then cons it onto the
  natural recursion.

  The Fourth Commandment: always change at least one
  argument while recurring. It must be changed to be
  closer to termination. The changing argument must be
  tested in the termination condition: when using cdr,
  test with null?
  """

  @doc """
  (rember 'mint '(lamb chops and mint jelly))
  => (lamb chops and jelly)

  (rember 'mint '(lamb chops and mint flavored mint jely))
  => (lamb chops and flavored mint jelly)

  (rember 'toast '(bacon lettuce and tomato)
  => (bacon lettuce and tomato)

  (rember 'cup '(coffee cup tea cup hick cup))
  => (coffee tea cup hick cup)

  (define rember
    (lambda (n l)
      (cond
        ((null? l) '())
        ((eq? (car l) n)
         (cdr l))
        (else
          (cons (car l) (rember n (cdr l)))))))
  """
  def rember(_, []), do: []
  def rember(n, [n|t]), do: t
  def rember(n, [h|t]), do: [h | rember(n, t)]

  @doc """
  (firsts '((apple peach pumpkin)
            (plum pear cherry)
            (grape raisin pea)
            (bean carrot eggplant)))
  => (apple plum grape bean)

  (firsts '((a b) (c d) (e f)))
  => (a c e)

  (firsts '())
  => ()

  (firsts '((five plums)
            (four)
            (eleven green oranges)))
  => (five four eleven)

  (firsts '(((five plums) four)
            (eleven green oranges)
            ((no) more)))
  => ((five plums) eleven (no))

  (define firsts
    (lambda (l)
      (cond
        ((null? l) '())
        (else
          (cons (car (car l))
                (firsts (cdr l)))))))
  """
  def firsts([]), do: []
  def firsts([ [f|_] | t]), do: [f | firsts(t)]


  @doc """
  (insertR 'topping 'fudge '(ice cream with fudge for desert))
  => (ice cream with fudge topping for desert)

  (insertR 'jalapeno 'and '(tacos tamales and salsa))
  => (tacos tamales and jalapeno salsa)

  (insertR 'e 'd '(a b c d f g h))
  => (a b c d e f g h)

  (define insertR
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((eq? (car l) old)
         (cons old (cons new (insertR new old (cdr l)))))
        (else
          (cons (car l)
                (insertR new old (cdr l)))))))
  """
  def insertR(_, _, []), do: []
  def insertR(new, old, [old|t]), do: [old, new | t]
  def insertR(new, old, [h|t]), do: [h | insertR(new, old, t)]

   @doc """
   (define insertL
     (lambda (new old l)
       (cond
         ((null? l) '())
         ((eq? (car l) old)
          (cons new l))
         (else
           (cons (car l)
                 (insertL new old (cdr l)))))))
  """
  def insertL(_, _, []), do: []
  def insertL(new, old, list=[old|_]), do: [new | list]
  def insertL(new, old, [h|t]), do: [h | insertL(new, old, t)]

  @doc """
  (subst 'topping 'fudge '(ice cream with fudge for desert))
  => (ice cream with topping for dessert)

  (define subst
    (lambda (new old s)
      (cond
        ((null? s) '())
        ((eq? (car s) old)
         (cons new (cdr s)))
        (else
          (cons (car s)
                (subst new old (cdr s)))))))
  """
  def subst(_, _, []), do: []
  def subst(new, old, [old|t]), do: [new | t]
  def subst(new, old, [h|t]), do: [h | subst(new, old, t)]

  @doc """
  (subst2 `vanilla `chocolate 'banana
    `(banana ice cream with chocolate topping))
  => (vanilla ice cream with chocolate topping)

  (define subst2
    (lambda (new o1 o2 s)
      (cond
        ((null? s) '())
        ((or (eq? (car s) o1)
             (eq? (car s) o2))
         (cons new (cdr s)))
        (else
          (cons (car s)
                (subst2 new o1 o2 (cdr s)))))))
  """
  def subst2(_, _, _, []), do: []
  def subst2(new, o1, _, [o1|t]), do: [new | t]
  def subst2(new, _, o2, [o2|t]), do: [new | t]
  def subst2(new, o1, o2, [h|t]), do: [h, subst2(new, o1, o2, t)]

  @doc """
  (multirember 'cup '(coffee cup tea cup and hick cup))
  => (coffee tea and hick)

  (define multirember
    (lambda (a lat)
      (cond
        ((null? lat) '())
        ((eq? (car lat) a)
         (multirember a (cdr lat)))
        (else
          (cons (car lat)
                (multirember a (cdr lat)))))))
  """
  def multirember(_, []), do: []
  def multirember(a, [a|t]), do: multirember(a, t)
  def multirember(a, [h|t]), do: [h | multirember(a,t)]

  @doc """
  (multiinsertR 'x 'y '(a y b y))
  => (a y x b y x)

  (define multiinsertR
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((eq? (car l) old)
         (cons old (cons new (multiinsertR new old (cdr l)))))
        (else
          (cons (car l)
                (multiinsertR new old (cdr l)))))))
  """
  def multiinsertR(_, _, []), do: []
  def multiinsertR(new, old, [old|t]), do: [old, new | multiinsertR(new, old, t)]
  def multiinsertR(new, old, [h|t]), do: [h | multiinsertR(new, old, t)]

  @doc """
  (multiinsertL 'x 'y '(a y b y))
  => (a x y b x y)

  (define multiinsertL
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((eq? (car l) old)
         (cons new (cons old (multiinsertL new old (cdr l)))))
        (else
          (cons (car l)
                (multiinsertL new old (cdr l)))))))
  """
  def multiinsertL(_, _, []), do: []
  def multiinsertL(new, old, [old|t]), do: [new, old | multiinsertL(new, old, t)]
  def multiinsertL(new, old, [h|t]), do: [h | multiinsertL(new, old, t)]

  @doc """
  (multisubst 'foo 'bar '(my other bar is a bar))
  => '(my other foo is a foo)

  (define multisubst
    (lambda (new old s)
      (cond
        ((null? s) '())
        ((eq? (car s) old)
         (cons new (multisubst new old (cdr s))))
        (else
          (cons (car s)
            (multisubst new old (cdr s)))))))
  """
  def multisubst(_, _, []), do: []
  def multisubst(new, old, [old|t]), do: [new | multisubst(new, old, t)]
  def multisubst(new, old, [h|t]), do: [h | multisubst(new, old, t)]
end
