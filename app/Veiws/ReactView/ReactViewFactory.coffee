define (require) ->
  (template) ->
    require('inherit') require('./AbstractReactView'),
      _getTemplate: -> template
