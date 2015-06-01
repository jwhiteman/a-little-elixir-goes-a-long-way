defmodule Schemer.FullOfStars do
  @moduledoc """
  The First Commandment (_final version_):

  When recurring on a list of atoms, _lat_, ask two questions about it:
  `(null? lat)` and `else`.

  When recurring on a number, _n_, ask two questions about it:
  `(zero? n)` and `else`.

  When recurring on a list of S-expressions, _l_, ask three questions about it:
  `(null? l)`, `(atom? (car l))`, and `else`.

  The Fourth Commandement (_final version_):

  Always change at least one argument while recurring. When recurring on a list
  of atoms, _lat_, use `(cdr lat)`. When recurring on a number, _n_, use `(sub1 n)`.
  And when recurring on a list of S-Expressions, _l_, use `(car l)` and `(cdr l)`
  if neither `(null? l)` nor `(atom? (car l))` are true.

  It must be changed closer to termination. The changing argument must be tested
  in the termination condition:

  when using _cdr_, test termination with _null?_ and when using _sub1_, test
  termination with _zero?_.
  """

  @doc """
  (define rember*
    (lambda (e l)
      (cond
        ((null? l) '())
        ((atom? (car l))
         (cond
           ((eq? (car l) e)
            (rember* e (cdr l)))
           (else
             (cons (car l)
               (rember* e (cdr l))))))
        (else
          (cons (rember* e (car l))
                (rember* e (cdr l)))))))

  (rember* 'cup '((coffee) cup ((tea) cup) (and (hick)) cup))
  => ((coffee) ((tea)) (and (hick)))

  (rember* 'sauce '(((tomato sauce))
                    ((bean) sauce)
                    (and ((flying)) sauce))
  => '(((tomato)) ((bean)) (and ((flying))))
  """
  def rember_star(_, []), do: []
  def rember_star(e, [e|t]) when is_atom(e), do: rember_star(e, t)
  def rember_star(e, [h|t]) when is_atom(h), do: [h | rember_star(e, t)]
  def rember_star(e, [h|t]), do: [rember_star(e, h) | rember_star(e, t)]

  @doc """
  (define insertR*
    (lambda (n o l)
      (cond
        ((null? l) '())
        ((atom? (car l))
         (cond
           ((eq? (car l) o)
            (cons o (cons n (insertR* n o (cdr l)))))
           (else
             (cons (car l) (insertR* n o (cdr l))))))
       (else
         (cons (insertR* n o (car l))
               (insertR* n o (cdr l)))))))

  (insertR* 'roast 'chuck 
  '((how much (wood))
   could
   ((a (wood) chuck))
   (((chuck)))
   (if (a) ((wood chuck)))
   could chuck wood))
  => ((how much (wood))
  could
  ((a (wood) chuck roast))
  (((chuck roast)))
  (if (a) ((wood chuck roast)))
  could chuck roast wood)
  """
  def insert_right_star(_, _, []), do: []
  def insert_right_star(n, o, [o|t]) when is_atom(o), do: [o | [n | insert_right_star(n, o, t)]]
  def insert_right_star(n, o, [h|t]) when is_atom(h), do: [h | insert_right_star(n, o, t)]
  def insert_right_star(n, o, [car = [_h|_t]|t]), do: [insert_right_star(n, o, car) | insert_right_star(n, o, t)]

  @doc """
  (define occur*
    (lambda (a l)
     (cond
       ((null? l) 0)
       ((atom? (car l))
        (cond
          ((eq? (car l) a)
           (add1 (occur* a (cdr l))))
          (else
            (occur* a (cdr l)))))
       (else 
         (+ (occur* a (car l))
            (occur* a (cdr l)))))))

  (occur* 'banana '((banana)
  (split ((((banana ice)))
  (cream (banana))
  sherbet)) (banana)
  (bread)
  (banana brandy)))
  => 5
  """
  def occur_star(_, []), do: 0
  def occur_star(a, [a|t]) when is_atom(a), do: 1 + occur_star(a, t)
  def occur_star(a, [h|t]) when is_atom(h), do: occur_star(a, t)
  def occur_star(a, [h|t]) when is_list(h), do: occur_star(a, h) + occur_star(a, t)

  @doc """
  (define subst*
    (lambda (n o l)
      (cond
        ((null? l) '())
        ((atom? (car l))
         (cond
           ((eq? (car l) o)
            (cons n (subst* n o (cdr l))))
           (else
             (cons (car l)
               (subst* n o (cdr l))))))
        (else
          (cons (subst* n o (car l))
                (subst* n o (cdr l)))))))

  (subst* 'orange 'banana
  '((banana)
  (split ((((banana ice))) (cream (banana))
  sherbet)) (banana)
  (bread)
  (banana brandy)))

  => 
  ((orange)
  (split ((((orange ice)))
  (cream (orange))
  sherbet)) (orange)
  (bread)
  (orange brandy))
  """
  def subst_star(_, _, []), do: []
  def subst_star(n, o, [o|t]) when is_atom(o), do: [n | subst_star(n, o, t)]
  def subst_star(n, o, [h|t]) when is_atom(h), do: [h | subst_star(n, o, t)]
  def subst_star(n, o, [h|t]), do: [subst_star(n, o, h) | subst_star(n, o, t)]

  @doc """
  (define insertL*
    (lambda (n o l)
      (cond
        ((null? l) '())
        ((atom? (car l))
         (cond
           ((eq? (car l) o)
            (cons n (cons o (insertL* n o (cdr l)))))
           (else
             (cons (car l)
                   (insertL* n o (cdr l))))))
        (else
          (cons (insertL* n o (car l))
                (insertL* n o (cdr l)))))))

  (insertL* 'pecker 'chuck '((how much (wood)) could
  ((a (wood) chuck)) (((chuck)))
  (if (a) ((wood chuck))) could chuck wood))
  => ((how much (wood))
  could
  ((a (wood) peeker chuck)) (((peeker chuck)))
  (if (a) ((wood peeker chuck))) could peeker chuck wood)
  """
  def insert_left_star(_, _, []), do: []
  def insert_left_star(n, o, [o|t]) when is_atom(o), do: [n | [o | insert_left_star(n, o, t)]]
  def insert_left_star(n, o, [h|t]) when is_atom(h), do: [h | insert_left_star(n, o, t)]
  def insert_left_star(n, o, [h|t]), do: [insert_left_star(n, o, h) | insert_left_star(n, o, t)]

  @doc """
  (define member*
    (lambda (a l)
      (cond
        ((null? l) #f)
        ((atom? (car l))
         (cond
           ((eq? (car l) a) #t)
           (else
             (member* a (cdr l)))))
        (else
          (or (member* a (car l))
              (member* a (cdr l)))))))

  (member* 'chips '((potato) (chips ((with) fish) (chips))))
  => #t
  """
  def member_star(_, []), do: false
  def member_star(a, [a|_]) when is_atom(a), do: true
  def member_star(a, [h|t]) when is_atom(h), do: member_star(a, t)
  def member_star(a, [h|t]), do: member_star(a, h) || member_star(a, t)

  @doc """
  (define leftmost
    (lambda (l)
      (cond
        ((atom? (car l))
         (car l))
        (else
          (leftmost (car l))))))

  (leftmost '((potato) (chips ((with) fish) (chips))))
  => potato

  (leftmost '(((hot) (tuna (and))) cheese))
  => hot

  (leftmost '(((() four)) 17 (seventeen)))
  => no answer

  (leftmost '())
  => no answer
  """
  def leftmost([h|_]) when is_atom(h), do: h
  def leftmost([h|_]), do: leftmost(h)

  """
  eqlist?
  equal?
  """

end
