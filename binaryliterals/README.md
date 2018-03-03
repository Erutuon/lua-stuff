To create a version of Lua 5.3.4 with basic support for binary literals, take the standard source code, replace llex.c and lobject.c with these modified versions, and then build as usual.

I simply modified the `read_numeral` function in the lexer to recognize the `0b` or `0B` prefix, and told `l_str2int` how to calculate the value of these number literals (as long as they only contain `0` or `1`). Now typing `0b1111` in the Lua interpreter yields `15`, and typing `1 + '0b11'` yields `4`.

It would be neat if `string.format('%b', 7)` yielded `111`, but that requires much more work, because the Lua format specifiers rely on C, and C doesn't have a binary format specifier (see [http://lua-users.org/lists/lua-l/2015-01/msg00199.html this message]).

To do: allow underscores (`0b1001_1100`).
