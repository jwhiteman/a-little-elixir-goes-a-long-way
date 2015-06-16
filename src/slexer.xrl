Definitions.

INT        = [0-9]+
ATOM       = [a-z_0-9\?\&\-\*\^\+]+
WHITESPACE = [\s\t\n\r]

Rules.

%% TODO: figure out what TokenLine does.
{INT}         : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
\#t           : {token, {bool, TokenLine, true}}.
\#f           : {token, {bool, TokenLine, false}}.
{ATOM}        : {token, {atom, TokenLine, to_atom(TokenChars)}}.
\(            : {token, {'(',  TokenLine}}.
\)            : {token, {')',  TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.

to_atom(Chars) ->
  list_to_atom(Chars).
