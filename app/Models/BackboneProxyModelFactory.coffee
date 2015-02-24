define (require) ->
  (ProxiedModel) ->
    require('inherit') require('Backbone').Model,
      __constructor: ->
        @_model = @_createModel.apply(@, arguments)
        return @__base.call(@)

      # Use save to sync backbone model with the actual data model
      save: -> throw new (require('../Error/NotImplementedError'))()

      _createModel: ->
        return new (ProxiedModel.bind.apply(ProxiedModel, arguments))()

      getModel: -> @_model
      getModelConstructor: -> ProxiedModel

