spawn = require('child_process').spawn
module.exports =

class JuliaProvider
  selector: '.source.julia'
  inclusionPriority: 10
  excludeLowerPriority: false

  julia: null

  constructor: ->
    @julia = spawn('julia', ["#{__dirname}/completions.jl"])

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    line = editor.buffer.lines[bufferPosition.row]
    pos = bufferPosition.column
    @julia.stdin.write "#{line}\n#{pos}\n"
    new Promise (resolve) =>
      @julia.stdout.once 'data', (result) ->
        if result?
          suggestions = result.toString().split('\n').filter((s) -> s.length > 0).map (s) ->
            [t, c] = s.split(' ')
            {
              text: c
              leftLabel: t unless t == 'nothing'
              type: juliaTypeIcon(c, t)
            }
          resolve(suggestions)

  dispose: ->
    @julia.kill()

isKeyword = (c) ->
  keywords = [ 'begin', 'end', 'for', 'while', 'if', 'else', 'elseif', 'return', 'function', 'do', 'try', 'catch' ]
  keywords.indexOf(c) != -1

juliaTypeIcon = (c, t) ->
  return 'keyword' if isKeyword(c)

  typemap =
    Function: 'function'
    DataType: 'type'
    TypeConstructor: 'type'
    Module: 'import'
    Int32: 'constant'
    Int64: 'constant'
    Float64: 'constant'
    ASCIIString: 'constant'
    nothing: ''

  typemap[t]
