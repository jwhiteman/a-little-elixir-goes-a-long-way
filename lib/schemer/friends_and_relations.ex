# Chapter 7.
defmodule Schemer.FriendsAndRelations do

  import Schemer.DoItAgain, only: [member: 2]
  import Schemer.ConsTheMagnificent, only: [firsts: 1]

  @doc """
  (define set?
    (lambda (lat)
      (cond
        ((null? lat) #t)
        ((member? (car lat) (cdr lat)) #f)
        (else
          (set? (cdr lat))))))

  (set? (quote (apple peaches apple plum)))
  => #f

  (set? (quote (apple peaches pears plums)))
  => #t

  (set? (quote (quote ())))
  => #t
  """
  def is_set([]), do: true
  def is_set([h|t]) do
    case member(h, t) do
      true  -> false
      false -> is_set(t)
    end
  end

  @doc """
  (define makeset
    (lambda (lat)
      (cond
        ((null? lat) '())
        ((member? (car lat) (cdr lat))
         (makeset (cdr lat)))
        (else
          (cons (car lat) (makset (cdr lat)))))))

  (makeset '(apple peach pear peach plum apple lemon peach))
  => (pear plum apple lemon peach)
  """
  def makeset([]), do: []
  def makeset([h|t]) do
    case member(h, t) do
      true  -> makeset(t)
      false -> [h | makeset(t)]
    end
  end

  @doc """
  ;; assume s1 & s2 are both sets.
  (define subset?
    (lambda (s1 s2)
      (cond
        ((null? s1) #t)
        ((member? (car s1) s2)
         (subset? (cdr s1) s2))
        (else #f))))

  (subset? '(5 chicken wings) '(5 chicken wings and 6 sodas))
  => #t

  (subset? '(a b c) '(a d e))
  => #f
  """
  def is_subset([], _), do: true
  def is_subset([h|t], s2) do
    case member(h, s2) do
      true  -> is_subset(t, s2)
      false -> false
    end
  end

  @doc """
  (define eqset?
    (lambda (s1 s2)
     (and (subset? s1 s2)
          (subset? s2 s1))))

  (eqset? '(6 large chickens with wings) '(6 chickens with large wings))
  => #t
  """
  def eqset(s1, s2), do: is_subset(s1, s2) && is_subset(s2, s1)

  @doc """
  (define intersect?
    (lambda (s1 s2)
      (cond
        ((null? s1) #f)
        ((member? (car s1) s2) #t)
        (else
          (intersect? (cdr s1) s2)))))

  (intersect? '(stewed tomatoes and macaroni) '(macaroni and cheese))
  => #t
  """
  def has_intersect([], _), do: false
  def has_intersect([h|t], s2) do
    case member(h, s2) do
      true  -> true
      false -> has_intersect(t, s2)
    end
  end

  @doc """
  (define intersect
    (lambda (s1 s2)
      (cond
        ((null? s1) '())
        ((member? (car s1) s2)
         (cons (car s1)
           (intersect (cdr s1) s2)))
        (else
         (intersect (cdr s1) s2)))))

  (intersect '(stewed tomatoes and macaroni) '(macaroni and cheese))
  => (and macaroni)
  """
  def intersect([], _), do: []
  def intersect([h|t], s2) do
    case member(h, s2) do
      true  -> [h | intersect(t, s2)]
      false -> intersect(t, s2)
    end
  end

  @doc """
  (define union
    (lambda (s1 s2)
      (cond
        ((null? s1) s2)
      ((member? (car s1) s2)
       (union (cdr s1) s2))
      (else
        (cons (car s1)
          (union (cdr s1) s2))))))

  (union '(stewed tomatoes and macaroni casserole)
         '(macaroni and cheese))
  => (stewed tomatoes casserole macaroni and cheese)
  """
  def union([], s2), do: s2
  def union([h|t], s2) do
    case member(h, s2) do
      true  -> union(t, s2)
      false -> [h | union(t, s2)]
    end
  end

  @doc """
  (define intersectall
    (lambda (l-set)
      (cond
        ((null? (cdr l-set)) (car l-set))
        (else
         (intersect (car l-set)
                    (intersect-all (cdr l-set)))))))

  (intersect-all '((a b c) (c a d e) (e f g h a b)))
  => (a)
  """
  def intersectall([h|[]]), do: h
  def intersectall([h|t]), do: intersect(h, intersectall(t))

  @doc """
  ;; assuming a list here...
  (define a-pair?
    (lambda (l)
      (and (not (null? l))
           (not (null? (cdr l)))
           (null? (cdr (cdr l))))))

  (a-pair? '(pear pear))
  => #t

  (a-pair? '(3 7))
  => #t

  (a-pair? '((2) (pair)))
  => #t

  (a-pair? '(full (house)))
  => #t
  """
  def is_pair([_,_]), do: true
  def is_pair(_), do: false

  @doc """
  ;; some helper functions that will be useful later on:

  (define first (lambda (l) (car l)))
  (define second (lambda (l) (car (cdr l))))
  (define build (lambda (s1 s2) (cons s1 (cons s2 '()))))
  (define third (lambda (l) (car (cdr (cdr l)))))
  """
  def first([f|_]), do: f
  def second([_,s|_]), do: s
  def third([_,_,t|_]), do: t
  def build(s1, s2), do: [s1 | [s2 | []]]

  @doc """
  ;; ...a finite function is a list of pairs in which no
  ;; first element of any pair is the same as any other
  ;; first element.

  (define fun? (lambda (l) (set? (firsts l))))

  (fun? '((a b) (c d) (d b)))
  => #t

  (fun? '((a b) (c d) (a e)))
  => #f
  """
  def is_fun(l), do: firsts(l) |> is_set

  @doc """
  (define revrel
    (lambda (rel)
      (cond
        ((null? rel) '())
        (else
         (cons (build (second (car rel))
                      (first (car rel)))
               (revrel (cdr rel)))))))

  (revrel '((8 a) (pumpkin pie) (got sick)))
  => ((a  8) (pie pumpkin) (sick got))
  """
  def revrel([]), do: []
  def revrel([[f,s]|t]), do: [[s,f] | revrel(t)]

  @doc """
  (define fullfun?
    (lambda (fun)
      (fun? (revrel fun))))

  (fullfun? '((grape raisin) (plum prune) (stewed prune)))
  => #f

  (fullfun? '((grape raisin) (plum prune) (stewed grape)))
  => #t
  """
  def is_fullfun(f), do: revrel(f) |> is_fun

end
