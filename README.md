# The Little Schemer in Elixir.

This repo contains the exercises and algorithms in the Little Schemer, ported to Elixir.
As well, each module contains my own Scheme solutions for easy comparison. I've also provided
unit tests where I could.

To run the tests, clone the project, `cd` into the repo directory and run:

```bash
mix test
```

To play around with the modules in the REPL run:


```bash
iex -S mix
```

## Notes on Scheme

If you're new to recursion (perhaps coming from Ruby) then you'll definitely want to buy the book and _work_ through it.

You can pick it up here: http://is.gd/ErC2bW

If you want to run Scheme code, give Dr. Racket a try: http://download.racket-lang.org/. It's available on Mac, Linux and Windows.
All the Scheme code in these exercises can be run as Racket without problem.

The official Little Schemer site is here:

http://www.ccs.neu.edu/home/matthias/BTLS/

It's worth checking out. They have an extra PDF with 35-pages of additional exercises not found in the book.

## Elixir Notes

Elixir isn't Scheme, so some exercises don't translate as well as others. There are quite a few things that take some
work in Scheme but are trivial in Elixir due to pattern matching. In some cases I tried to stick to the spirit of the
exercise; in other cases, I tried to leverage the power of pattern matching to the best of my abilities.

My hope is that having some variety will make the overall project more valuable. If you've got an interesting solution
that you'd like to see included, create a pull request.

Except in one or two examples, I made no attempt to make use of Elixir's concurrency primitives.

## Book Notes

Table of contents and general outline

1. **Toys**: the basics of car, cons & cdr
2. **Do it Again**: the basics of recursion using simple lists
3. **Cons the Magnificent**: list building and basic filtering and mapping
4. **Numbers Games**: true to the title, working with lists of numbers and basic math
5. **Oh My Gawd, It's Full of Stars**: working with lists of lists
6. **Shadows**: building your first simple evaluator
7. **Friends and Relations**: working with sets
8. **Lambda the Ultimate**: currying and continuation passing style
9. **...and Again, and Again**: the Y combinator
10. **What's the Value of All This?**: build your own basic Scheme, in Elixir!

Working through the book should give you enough knowledge to get you started building your own Scheme interpreter.

Mine is here: https://github.com/jwhiteman/lighthouse-scheme

_Bon Appétit_
