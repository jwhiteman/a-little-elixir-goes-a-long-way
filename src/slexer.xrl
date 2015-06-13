Definitions.

INT        = [0-9]+
ATOM       = [a-z_\?\&\-\*\^\+]+
WHITESPACE = [\s\t\n\r]

Rules.

{INT}         : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
{ATOM}        : {token, {atom, TokenLine, to_atom(TokenChars)}}.
\(            : {token, {'(',  TokenLine}}.
\)            : {token, {')',  TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.

to_atom(Chars) ->
  list_to_atom(Chars).
