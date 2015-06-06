using Base.REPL.REPLCompletions: completions, non_identifier_chars

const keywords = Set([
    "if"
    "else"
    "elseif"
    "while"
    "for"
    "begin"
    "end"
    "quote"
    "try"
    "catch"
    "return"
    "local"
    "abstract"
    "function"
    "macro"
    "ccall"
    "finally"
    "typealias"
    "break"
    "continue"
    "type"
    "global"
    "module"
    "using"
    "import"
    "export"
    "const"
    "let"
    "bitstype"
    "do"
    "in"
    "baremodule"
    "importall"
    "immutable"
])

const non_identifier_chars_set = Set(non_identifier_chars)

function typestring_helper(c)
    string(typeof(eval(parse(c))))
end

# c the completion
# s the source string
# r the range from which the completion was extracted
function typestring(c, s, r)
    if length(c) > 0 && c[1] == '@'
        "macro" # we know that c was a successful completion, so it must be a macro
    else
        # some completions don't have types and typeof throws an error
        try
            typestring_helper(c)
        catch
            if c in keywords
                "keyword"
            else
                # it exists, has no type, and is not a keyword?
                # it could be behind a namespace!
                pos = r[1] - 1
                while pos > 0 && (!(s[pos] in non_identifier_chars_set) || s[pos] == '.')
                    pos -= 1
                end
                pos += (pos == 0)

                full_name = string(s[pos:r[1]-1], c)

                try
                    typestring_helper(full_name)
                catch
                    "nothing"
                end
            end
        end
    end
end

while true
    line = readline()
    pos = readline()
    try
        pos = int(pos) # fails if pos cannot be converted to integer
        completions_array, subrange, success = completions(line, pos)
        fuzzy_completions_array, = completions(line, subrange[1])
        final_completions_array = unique([completions_array, fuzzy_completions_array])
        completion_strings = map(final_completions_array) do c
            "$(typestring(c, line, subrange)) $c"
        end
        println(join(completion_strings, '\n'))
    catch
        # don't return anything on bad input
    end
end
