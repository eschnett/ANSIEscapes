# ANSIEscapes.jl: ANSI escape sequences for terminal control

[ANSI escape
sequences](https://en.wikipedia.org/wiki/ANSI_escape_code) are a
standard for in-band signaling to control cursor location, color, font
styling, and other options on video text terminals and terminal
emulators. Certain sequences of bytes, most starting with an ASCII
escape character and a bracket character, are embedded into text. The
terminal interprets these sequences as commands, rather than text to
display verbatim.

ANSI sequences were introduced in the 1970s to replace vendor-specific
sequences and became widespread in the computer equipment market by
the early 1980s. Although hardware text terminals have become
increasingly rare in the 21st century, the relevance of the ANSI
standard persists because a great majority of terminal emulators and
command consoles interpret at least a portion of the ANSI standard.

ANSI escape sequences allow specifying colour, font attributes (bold,
italic, underlined), moving the cursor, hiding the curser, erasing
lines, and offer many more functions. They also allow querying the
terminal about its capabilites, size, current cursor position, and
more.

## Note

When experimenting with these escape sequences, it is easy to get the
terminal into a state where it "doesn't work properly any more". The
cursor might be invisible, scrolling or line breaks might look weird,
the text might be white on white or black on black, the keys you type
might produce no output, etc.

In this case, you can use the shell command `reset` to reset the
terminal back into its normal state. You might have to type this
command blind. When it works, `reset` will clean the screen and
everything will be back to normal. In the Julia repl, you can press
control-C a few times to abort the currently running command and to
start a new line in the repl, then use the semicolon key `;` to enter
shell mode, and then type `reset` and press "enter".

## Examples

Determine the terminal window size:

```julia
julia> using ANSIEscapes
julia> const AE = ANSIEscapes
julia> nrows, ncols = AE.read_window_size()
(82, 138)
```

Move the cursor to row 10, erase the line, write "Hello, World!"
there, and move the cursor back to its current position:

```julia
julia> using ANSIEscapes
julia> const AE = ANSIEscapes
julia> print(AE.SCP())        # save cursor position
julia> print(AE.CUP(10, 1))   # position cursor at row 10, column 1
julia> print(AE.SGR_fgcolor(AE.red), "*** Hello, World! ***", AE.SGR_fgcolor_default())
julia> print(AE.EL())         # erase to end of line
julia> print(AE.RCP())        # restore cursor position
```
