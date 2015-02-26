define [
  '_', 'inherit', 'assert'
  './MessageBody/AbstractMessageBody'
  './Destination/AbstractDestination'
  './Label/AbstractLabel'
], (_, inherit, assert, AbstractMessageBody, AbstractDestination, AbstractLabel) ->
  checkDestinations = (destinations) -> _.each destinations, (destination) -> assert destination instanceof AbstractDestination, 'Destination expected'

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
      return @

    getTitle: -> @_title
    setTitle: (title) ->
      assert typeof title is 'string'
      @_title = title
      return @

    to: (destinations...) ->
      checkDestinations destinations
      @_to = @_to.concat destinations
      return @

    cc: (destinations...) ->
      checkDestinations destinations
      @_cc = @_cc.concat destinations
      return @

    # Check message has a label of a given type
    hasLabelByType: (Label) ->
      assert typeof Label is 'function'
      Boolean _.find(@_labels, (label) -> label instanceof Label)

    addLabel: (label) ->
      assert label instanceof AbstractLabel
      @_labels.push(label)
      return @

    getRecipients: ->
      return @_to.concat @_cc.concat @_bcc
