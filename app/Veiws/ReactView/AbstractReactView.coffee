define (require) ->
  NotImplementedError = require '../../Error/NotImplementedError'

  require('inherit') require('../AbstractView/AbstractView'),
    # Should return a jsx template function
    # @returns Function
    _getTemplate: -> throw new NotImplementedError();

    _getClass: ->
      @__self._getReact().createClass @_getClassHooks()

    _getClassHooks: ->
      that = @
      render: -> that._getTemplate().call(@)
      getModel: -> that.model

    getID: -> @model?.id or @model?.cid or @_id or @_id = require('util').uuid()

    render: ->
      return @_element if @_element
      @_element = @__self._getReact().createElement @_getClass()
  ,
    # Injection method for testing
    _getReact: -> require 'React'
