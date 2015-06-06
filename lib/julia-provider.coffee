spawn = require('child_process').spawn
module.exports =

class JuliaProvider
  selector: '.source.julia'
  inclusionPriority: 0
  excludeLowerPriority: false
  filterSuggestions: true

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
              leftLabel: t
              type: juliaTypeIcon(t)
            }
          resolve(suggestions)

  dispose: ->
    @julia.kill()

juliaTypeIcon = (t) ->
  typemap =
    Function: 'function'
    DataType: 'type'
    TypeConstructor: 'type'
    Module: 'import'
    macro: 'tag'
    keyword: 'keyword'
    nothing: ''

  if typemap[t] != undefined
    typemap[t]
  else
    'constant'
