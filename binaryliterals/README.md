These three files allow binary literals for integers, marked by the prefix `0b`, as well as underscores in integer literals. Only Lua 5.3.4 is supported. Simply take the standard source code, replace lctype.h, llex.c, and lobject.c with these modified versions, and then build as usual.

I simply modified the `read_numeral` function in the lexer to recognize the `0b` or `0B` prefix, and told `l_str2int` how to calculate the value of these number literals (as long as they only contain `0` or `1`). Now typing `0b1111` in the Lua interpreter yields `15`, and typing `1 + '0b11'` yields `4`.

Binary literals for floats are not supported, nor are underscores in floats; `0b1.1` and `1_000_000.50` will be rejected by the parser.

It would be neat if `string.format('%b', 7)` yielded `111`, but that requires much more work, because the Lua format specifiers rely on C, and C doesn't have a binary format specifier (see [this message](http://lua-users.org/lists/lua-l/2015-01/msg00199.html "Re: Binary literals and number separators.") in the Lua mailing list).
