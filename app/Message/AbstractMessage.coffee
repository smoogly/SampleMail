require [
  '_', 'inherit', 'assert'
  'MessageBody/AbstractMessageBody.coffee'
  'Destination/AbstractDestination.coffee'
], (_, inherit, assert, AbstractMessageBody, AbstractDestination) ->
  checkDestinations = (destinations) -> _.each destinations, (destination) -> assert destination instanceof AbstractDestination

  inherit
    constructor: ->
      @_to = []
      @_cc = []
      @_bcc = []

    getBody: -> @_body
    setBody: (body) ->
      assert body instanceof AbstractMessageBody
      @_body = body

    getTitle: -> @_title
    setTitle: (title) ->
      assert typeof title is 'string'
      @_title = title

    to: (destinations...) ->
      checkDestinations destinations
      @_to.concat destinations

    cc: (destinations...) ->
      checkDestinations destinations
      @_cc.concat destinations
