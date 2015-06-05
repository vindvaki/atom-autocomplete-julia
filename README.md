# atom-autocomplete-julia package

## Components


### Atom (the client)

- Manages the Julia subprocess
- Communicates with the Julia subprocess via some API

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

The input should be a string and the cursor position, and the output will be of
the form

```
N
typeof(completion_1) completion_1
typeof(completion_2) completion_2
.
.
.
typeof(completion_N) completion_N
```

where `N` is the number of completions and

```
array_of_completions = [completion_1, completion_2, ..., completion_N]

```
