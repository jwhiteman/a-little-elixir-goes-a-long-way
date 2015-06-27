defmodule Schemer.ConsTheMagnificent.Alternate do
  def multirember(e, l), do: multirember(e, l, [])
  def multirember(_, [], acc), do: :lists.reverse(acc)
  def multirember(e, [e|t], acc), do: multirember(e, t, acc)
  def multirember(e, [h|t], acc), do: multirember(e, t, [h|acc])

  def multiinsertR(n, o, l), do: multiinsertR(n, o, l, [])
  def multiinsertR(_, _, [], acc), do: :lists.reverse(acc)
  def multiinsertR(n, o, [o|t], acc), do: multiinsertR(n, o, t, [n, o | acc])
  def multiinsertR(n, o, [h|t], acc), do: multiinsertR(n, o, t, [h | acc])

  def multiinsertL(n, o, l), do: multiinsertL(n, o, l, [])
  def multiinsertL(_, _, [], acc), do: :lists.reverse(acc)
  def multiinsertL(n, o, [o|t], acc), do: multiinsertL(n, o, t, [o, n | acc])
  def multiinsertL(n, o, [h|t], acc), do: multiinsertL(n, o, t, [h | acc])

  def multisubst(n, o, l), do: multisubst(n, o, l, [])
  def multisubst(_, _, [], acc), do: :lists.reverse(acc)
  def multisubst(n, o, [o|t], acc), do: multisubst(n, o, t, [n | acc])
  def multisubst(n, o, [h|t], acc), do: multisubst(n, o, t, [h | acc])
end
