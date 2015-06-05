module.exports =
  provider: null

  activate: (state) ->

  deactivate: ->
    @provider.dispose()
    @provider = null

  provide: ->
    unless @provider?
      JuliaProvider = require('./julia-provider')
      @provider = new JuliaProvider()

    @provider
