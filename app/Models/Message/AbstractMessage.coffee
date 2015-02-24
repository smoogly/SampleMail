define [
  '_', 'inherit', 'assert'
  './MessageBody/AbstractMessageBody'
  './Destination/AbstractDestination'
  './Label/AbstractLabel'
], (_, inherit, assert, AbstractMessageBody, AbstractDestination, AbstractLabel) ->
  checkDestinations = (destinations) -> _.each destinations, (destination) -> assert destination instanceof AbstractDestination

  inherit
    __constructor: ->
      @_labels = []

      @_to = []
      @_cc = []
      @_bcc = []

      return @ #Otherwise there would be return @_bcc = [] compiled :/

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

    # Check message has a label of a given type
    hasLabelByType: (Label) ->
      assert typeof Label is 'function'
      Boolean _.find(@_labels, (label) -> label instanceof Label)

    addLabel: (label) ->
      assert label instanceof AbstractLabel
      @_labels.push(label)

    getRecipients: ->
      return @_to.concat @_cc.concat @_bcc
