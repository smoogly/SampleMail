define (require) ->
  NotImplementedError = require '../../Error/NotImplementedError'

  require('inherit') require('../AbstractView/AbstractView'),
    __constructor: (attrs) ->
      @__base.apply(@, arguments)
      @model.on('change', @trigger.bind(@, @__self.ONCHANGE_EVENT_NAME)) if @model?
      @model.once('destroy', @remove.bind(@)) if @model?
      return @

    # Should return a jsx template function
    # @returns Function
    _getTemplate: -> throw new NotImplementedError();

    _getClass: ->
      @__self._getReact().createClass @_getClassHooks()

    _getClassHooks: ->
      that = @
      ONCHANGE_EVENT_NAME = @__self.ONCHANGE_EVENT_NAME

      render: -> that._getTemplate().call(@)

      onChange: -> @setState(that.model.toJSON()) if that.model?

      componentWillMount: ->
        do @onChange
        that.on(ONCHANGE_EVENT_NAME, @onChange)

      componentWillUnmount: ->
        that.off(ONCHANGE_EVENT_NAME)

    getID: -> @model?.id or @model?.cid or @_id or @_id = require('util').uuid()

    render: ->
      return @_element if @_element
      @_element = @__self._getReact().createElement @_getClass()
  ,
    # Injection method for testing
    _getReact: -> require 'React'

    ONCHANGE_EVENT_NAME: 'change'
