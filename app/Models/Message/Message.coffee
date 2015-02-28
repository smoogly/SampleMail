define ['assert', 'inherit', './AbstractMessage', './Label/TrashLabel'], (assert, inherit, AbstractMessage, TrashLabel) ->
  inherit AbstractMessage,
    getID: -> # This should be actually set by the backend, but there is none
      return @_id if @_id
      @_id = require('util').uuid()

    setID: (id) ->
      assert id and typeof id is 'string', 'Id should be a string'
      @_id = id
      return @

    toTrash: ->
      @addLabel(new TrashLabel()) unless @hasLabelByType(TrashLabel)
      return @
