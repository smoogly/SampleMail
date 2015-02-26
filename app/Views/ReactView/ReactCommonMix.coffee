define (require) ->
  require('inherit')
    setModel: (model) ->
      require('assert') not model? or model instanceof require('Backbone').Model, 'Backbone model required'

      # Unbind previous model if there is one
      @stopListening(@model, 'change destroy') if @model?

      # Set the reference
      modelChanged = model isnt @model
      @model = model;

      if @model?
        # Bind events
        @listenTo(@model, 'change', @trigger.bind(@, @__self.ONCHANGE_EVENT_NAME))
        @listenToOnce(@model, 'destroy', @remove.bind(@))

      # There's a new Model!
      @trigger(@__self.MODEL_CHANGE_EVENT_NAME) if modelChanged

    getID: -> @model?.id or @model?.cid or @_id or @_id = require('util').uuid()

    _getClass: -> @__self._getReact().createClass @_getClassHooks()

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

  ,
    # Injection method for testing
    _getReact: -> require 'React'

    ONCHANGE_EVENT_NAME: 'change'
    MODEL_CHANGE_EVENT_NAME: 'modelchange'
