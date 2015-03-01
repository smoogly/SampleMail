define [
  'inherit'
  './AbstractLabel'
], (inherit, AbstractLabel) ->
  inherit AbstractLabel, {},
    getType: -> 'Trash'
