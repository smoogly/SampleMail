define (require) ->
  (ProxiedModel) ->
    require('inherit') require('Backbone').Model,
      __constructor: ->
        @_model = new (ProxiedModel.bind.apply(ProxiedModel, arguments))()
        return @__base.call(@)

      # Use save to sync backbone model with the actual data model
      save: -> throw new (require('../Error/NotImplementedError'))()

      getModel: -> @_model
      getModelConstructor: -> ProxiedModel

