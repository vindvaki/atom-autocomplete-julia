# atom-autocomplete-julia package

Currently just barely usable.

## Components

d### Atom (the client)

- Manages the Julia child process
- Communicates with the Julia child process through stdio
- Interprets the suggestion results from the Julia child process

### Julia (the server)

#### Completions algorithm

The heavy lifting is done by

```
Base.REPL.REPLCompletions.completions(string, pos)
```

The output is a tuple of the form

```
(array_of_completions, subrange_being_completed, success?)
```

#### Interface

The input should be a string and the cursor position, and the output should be zero
or more lines of the form

```
typeof(completion) completion
```
