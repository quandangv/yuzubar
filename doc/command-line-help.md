## DESCRIPTION

**`yuzubar`** `[options] <path-list>`

Displays a status bar using the text retrieved from a Linkt tree, which is created by merging the the Linkt trees parsed from the files in `path-list`.

For more information on how Linkt trees are parsed, go to the Linkt repo: https://github.com/quandangv/linkt

## OPTIONS

|||
|-:|------------------|
|_**-l** cmd_|Fork and call `cmd` to display the bar. Lemonbar-style text will be written to the process's stdin|
|_**-h**_|Display this help and exit|
|_**-k**_|Use pkill to kill all previous instances of yuzubar and lemonbar|
|_**-f**_|Specify font for Lemonbar. Can be used multiple times to load more than a single font.|
