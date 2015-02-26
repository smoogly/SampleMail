define (require) ->
  require('inherit') require('Backbone').View,
    render: -> throw new (require('../../Error/NotImplementedError'))()

