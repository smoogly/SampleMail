define (require) ->
  NotImplementedError = require '../../Error/NotImplementedError'

  require('inherit') [require('../AbstractView/AbstractView'), require('./ReactCommonMix')],
    __constructor: (attrs) ->
      @__base.apply(@, arguments)
      @setModel(attrs?.model)
      return @

    # Should return a jsx template function
    # @returns Function
    _getTemplate: -> throw new NotImplementedError();

    render: ->
      return @_element if @_element
      @_element = @__self._getReact().createElement @_getClass()
