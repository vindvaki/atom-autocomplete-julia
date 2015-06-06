import Base.REPL.REPLCompletions.completions

keywords = Set([
    "begin",
    "end",
    "for",
    "while",
    "if",
    "else",
    "elseif",
    "return",
    "function",
    "do",
    "try",
    "catch",
    "type",
    "typealias"
])

nonconstants = Set([
    DataType,
    Module
])

function typestring(c)
    if length(c) > 0 && c[1] == '@'
        "macro" # we know that c was a successful completion, so it must be a macro
    else
        try
            string(typeof(eval(parse(c))))
        catch
            if c in keywords
                "keyword"
            else
                # it exists but does not have a valid type?
                "nothing"
            end
        end
    end
end

while true
    string = readline()
    pos = readline()
    try
        pos = int(pos) # fails if pos cannot be converted to integer
        completions_array, subrange, success = completions(string, pos)
        fuzzy_completions_array, = completions(string, subrange[1])
        final_completions_array = unique([completions_array, fuzzy_completions_array])
        completion_strings = map(final_completions_array) do c
            "$(typestring(c)) $c"
        end
        println(join(completion_strings, '\n'))
    catch
        # don't return anything on bad input
    end
end
