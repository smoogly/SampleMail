define [
  '_', 'inherit', 'assert'
  '../../Error/NotImplementedError'
  './MessageBody/AbstractMessageBody'
  './Destination/AbstractDestination'
  './Label/AbstractLabel'
], (_, inherit, assert, NotImplementedError, AbstractMessageBody, AbstractDestination, AbstractLabel) ->
  checkDestinations = (destinations) -> _.each destinations, (destination) -> assert destination instanceof AbstractDestination, 'Destination expected'

  AbstractMessage = inherit
    __constructor: ->
      @_labels = []

      @_to = []
      @_cc = []
      @_bcc = []
      @_from = null;

      return @

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

    from: (destinatioin) ->
      checkDestinations([destinatioin])
      @_from = destinatioin
      return @

    getTo: -> @_to

    getFrom: ->
      assert @_from isnt null, 'From field has never been defined'
      return @_from

    # Check message has a label of a given type
    hasLabelByType: (Label) ->
      assert typeof Label is 'function'
      Boolean _.find(@_labels, (label) -> label instanceof Label)

    addLabel: (label) ->
      assert label instanceof AbstractLabel
      @_labels.push(label)
      return @

    getLabels: -> @_labels

    getRecipients: ->
      return @_to.concat @_cc.concat @_bcc

  ,
    factory: (serializedMessage) ->
      throw new NotImplementedError() #TODO: implement

    serializer: (message) ->
      assert message instanceof AbstractMessage, 'Abstract message expected'

      JSON.stringify
        title: message.getTitle()
        body: AbstractMessageBody.serialize message.getBody()
        labels: message.getLabels().map AbstractLabel.serialize
        to: message.getTo().map AbstractDestination.serialize

  return AbstractMessage
