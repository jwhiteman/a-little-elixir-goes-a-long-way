defmodule Schemer.FullOfStars do
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
  def remberS(_, []), do: []
  def remberS(e, [e|t]) when is_atom(e), do: remberS(e, t)
  def remberS(e, [h|t]) when is_atom(h), do: [h | remberS(e, t)]
  def remberS(e, [h|t]), do: [remberS(e, h) | remberS(e, t)]

  """
  insertR*
  occur*
  subst*
  insertL*
  member*
  leftmost
  eqlist?
  equal?
  """

end
