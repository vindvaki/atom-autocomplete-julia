# atom-autocomplete-julia package

Uses the new built-in autocomplete+ API.

![screenshot](https://raw.githubusercontent.com/vindvaki/atom-autocomplete-julia/master/atom-autocomplete-julia.png)

## What it does

Prefix matching within the context of the current line.

## What it doesn't do (yet)

- Fuzzy matching
- Matching based on current project

## Known issues

Sometimes the Julia child process starts using up 100% CPU

# Implementation details

You can ignore this section if you're not interested in improving this package.

The package is in its early stages. Just a few lines of code really, so it's
the perfect time to jump in and improve it.

## Atom (the client)

- Manages the Julia child process
- Communicates with the Julia child process through stdio
- Interprets the suggestion results from the Julia child process

## Julia (the server)

### Completions algorithm

The heavy lifting is done by

```
Base.REPL.REPLCompletions.completions(string, pos)
```
from Julia. The output of this function is a tuple of the form

```
(array_of_completions, subrange_being_completed, success?)
```

### Interface

The input should be a string and the cursor position, and the output should be
zero or more lines of the form

```
typeof(eval(parse(completion))) completion
```

if `parse(eval(completion))` exists. If not, additional heuristics need to be
applied to determine the type.
