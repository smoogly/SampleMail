define (require) ->
  require('inherit') require('Backbone').Model,
    __constructor: (model) ->
      @_model = model
      return @__base.call(@)

    # Use save to sync backbone model with the actual data model
    save: -> throw new (require('../Error/NotImplementedError'))()

    getModel: -> @_model
