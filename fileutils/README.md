This module simplifies getting and modifying the contents of files. Each function takes a file path as the first argument. 

## Basic functions

* `fileutils.readall(filepath)`
Returns the contents of a file.
* `fileutils.write(filepath, content)`
Writes `content` to file.
* `fileutils.modify(filepath, modify_func)`
Modifies a file. `modify_func` receives the text of the file; it must return a string, or else the file will not be modified.
* `length(filepath)`
Returns the length of the file in bytes.

## String operations on file contents
fileutils autogenerates functions corresponding to each of the pattern-matching functions in the basic `string` library, and adds a plain gsub function, `string.pgsub`. The first argument is a filepath rather than a string. For example, `fileutils.match('fileutils.lua', '%w+')` calls `string.match` on the contents of fileutils.lua and returns the first sequence of word characters.
