# Chapter 6
defmodule Schemer.Shadows do

  @moduledoc """
  The Seventh Commandment: Recur on the _subparts_ that are the same in nature:
  - On the sublists of a list. 
  - On the subexpressions of an arithmetic expression.

  The Eighth Commandment: Use help functions to abstract from representations.
  """

  @doc """
  (numbered? '(1 + 1))
  => #t

  (numbered? 1)
  => #t

  (numbered? '(3 + (4 * 5)))
  => #t

  (numbered? '(3 * sausage))
  => #f

  (define numbered?
    (lambda (e)
      (cond
        ((atom? e)(number? e))
         (else
           (and (or (number? (car e))
                    (numbered? (car e)))
                (or (eq? (car (cdr e)) '+)
                    (eq? (car (cdr e)) '*)
                    (eq? (car (cdr e)) '^))
                (or (number? (car (cdr (cdr e))))
                    (numbered? (car (cdr (cdr e))))))))))
  """
  def numbered([left, operator, right]) do
    numbered(left) && valid_operator(operator) && numbered(right)
  end

  def numbered(n), do: is_number(n)

  defp valid_operator(:+), do: true
  defp valid_operator(:*), do: true
  defp valid_operator(:^), do: true
  defp valid_operator(_), do: false

  @doc """
  (value 13)
  => 13

  (value '(1 + 3))
  => 4

  (value '(1 + (3 ^ 4)))
  => 82

  (define value
    (lambda (nexp)
      (cond
        ((atom? nexp) nexp)
        ((eq? (car (cdr nexp)) '+)
         (+ (value (car nexp))
            (value (car (cdr (cdr nexp))))))
        ((eq? (car (cdr nexp)) '*)
         (* (value (car nexp))
            (value (car (cdr (cdr nexp))))))
        (else
           (pow (value (car nexp))
                (value (car (cdr (cdr nexp)))))))))
  """
  def value([l, :+, r]), do: value(l) + value(r)
  def value([l, :*, r]), do: value(l) * value(r)
  def value([l, :^, r]), do: pow(value(l), value(r))
  def value(n) when is_number(n), do: n

  @doc """
  (define 1st-sub-expression
    (lambda (exp)
      (car (cdr exp))))

   (define 2nd-sub-expression
     (lambda (exp)
       (car (cdr (cdr exp)))))
   
   (define operator
     (lambda (exp)
       (car exp)))
   
   (define generic-value
     (lambda (nexp)
       (cond
         ((atom? nexp) nexp)
         ((eq? (operator nexp) '+)
          (+ (generic-value (1st-sub-expression nexp))
             (generic-value (2nd-sub-expression nexp))))
         ((eq? (operator nexp) '*)
          (* (generic-value (1st-sub-expression nexp))
             (generic-value (2nd-sub-expression nexp))))
         (else
          (pow (generic-value (1st-sub-expression nexp))
             (generic-value (2nd-sub-expression nexp)))))))
  """
  def generic_value(n) when is_number(n), do: n
  def generic_value([_,_,_]=aexp) do
    case operator_for(aexp) do
      :+ -> first_sub_expression(aexp) + second_sub_expression(aexp)
      :* -> first_sub_expression(aexp) * second_sub_expression(aexp)
      :^ -> pow(first_sub_expression(aexp), second_sub_expression(aexp))
    end
  end

  @doc """
  (define sero?
  (lambda (n)
    (null? n)))

  (define edd1
    (lambda (n)
      (cons '() n)))
  
  (define zub1
    (lambda (n)
      (cdr n)))
  
  (define sadd
    (lambda (n m)
      (cond
        ((sero? m) n)
        (else
         (edd1 (sadd n (zub1 m)))))))
  """
  def sero([]), do: true
  def sero(_), do: false

  def edd1(l), do: [[]|l]

  def zub1([_|t]), do: t

  def sadd(n, m) do
    cond do
      sero(m) -> n
      true    -> edd1(sadd(n, zub1(m)))
    end
  end

  def operator_for([_, :+, _]), do: :+
  def operator_for([_, :*, _]), do: :*
  def operator_for([_, :^, _]), do: :^

  def first_sub_expression([sub, _, _]), do: generic_value(sub)
  def second_sub_expression([_, _, sub]), do: generic_value(sub)

  def pow(_, 0), do: 1
  def pow(n, m), do: n * pow(n, m-1)
end
