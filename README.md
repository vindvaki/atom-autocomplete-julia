# autocomplete-julia: Auto-Completion for Julia in Atom

Uses the new built-in autocomplete+ API.

## Features

- Fuzzy matching within the context of the current line
- Type icons and hints for suggestions
- Falls back to other available providers for awareness of buffer contents

![screenshot](https://raw.githubusercontent.com/vindvaki/atom-autocomplete-julia/master/atom-autocomplete-julia.png)


## TODO

### Project aware suggestions

I.e. parse project (or at least the current buffer) and show suggestions. This includes things like knowing that `completions` in `lib/completions.jl` (of this package) comes from the module `Base.REPL.REPLCompletions` because of the line

```julia
using Base.REPL.REPLCompletions: completions, non_identifier_chars
```

This could be done by evaluating the `using`/`import` statements in the Julia child process, but we don't want to do that because that can lead to evaluating code with side effects.

Using the REPL completions is essentially a local maximum: It works well and can be very useful if refined, but to do project awareness well we need a more sophisticated infrastructure (e.g. use the official [julia-parser.scm](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm) or [JuliaParser.jl](https://github.com/jakebolewski/JuliaParser.jl))

## Known issues

Sometimes the Julia child process starts using up 100% CPU

# Implementation details

You can ignore this section if you're not interested in improving this package.

The package is in its early stages. Just a few lines of code really, so it's the perfect time to jump in and improve it.

## Atom (the client)

- Manages the Julia child process
- Communicates with the Julia child process through stdio
- Interprets the suggestion results from the Julia child process


## Julia (the server)

See `lib/completions.jl`

### Completions algorithm

The heavy lifting is done by

```julia
Base.REPL.REPLCompletions.completions(string, pos)
```
from Julia. The output of this function is a tuple of the form

```
(array_of_completions, subrange_being_completed, success?)
```

### Interface

The input is a pair of lines:

```
line in the buffer               <-- first line
cursor position within the line  <-- second line
```

The output should be zero or more lines of the form

```
typeof(eval(parse(completion))) completion
```

if `parse(eval(completion))` exists. If not, additional heuristics need to be
applied to determine the type.
