import Base.REPL.REPLCompletions.completions

while true
    string = readline()
    pos = readline()
    try
        pos = int(pos) # fails if pos cannot be converted to integer
        completions_array, subrange, success = completions(string, pos)
        completion_strings = map(completions_array) do c
            t = try
                typeof(eval(parse(c)))
            catch
                if success && length(c) > 0 && c[1] == '@'
                    "macro"
                else
                    "nothing"
                end
            end
            "$t $c"
        end
        println(join(completion_strings, '\n'))
    catch
    end
end
