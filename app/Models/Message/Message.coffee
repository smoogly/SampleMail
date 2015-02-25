define ['inherit', './AbstractMessage'], (inherit, AbstractMessage) ->
  inherit AbstractMessage,
    getID: -> # This should be actually set by the backend, but there is none
      return @_id if @_id
      @_id = require('util').uuid()
