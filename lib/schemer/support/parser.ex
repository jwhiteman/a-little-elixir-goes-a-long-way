defmodule Schemer.Support.Parser do
  def parse(str) do
    {:ok, tokens, _} = str |> to_char_list |> :slexer.string
    {:ok, list}      = :sparser.parse(tokens)
    list
  end
end
