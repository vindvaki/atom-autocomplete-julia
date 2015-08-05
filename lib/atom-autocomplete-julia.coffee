JuliaProvider = require('./julia-provider')

module.exports =
  config:
    juliaPath:
      type: 'string'
      default: 'julia'
      description: 'Which Julia binary should the completions server use?'

  provider: null

  activate: (state) ->
    atom.config.onDidChange 'autocomplete-julia.juliaPath', ({newValue, oldValue}) =>
      if @provider?
        @provider.dispose()
      @provider = new JuliaProvider(newValue)
      # FIXME? Better handling of errors in case newValue is wrong. The error
      # messages can get pretty annoying for slow typists.

  deactivate: ->
    @provider.dispose()
    @provider = null

  provide: ->
    unless @provider?
      @provider = new JuliaProvider(@getJuliaPath())
    @provider

  getJuliaPath: ->
    atom.config.get('autocomplete-julia.juliaPath')
