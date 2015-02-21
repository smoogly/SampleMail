define [
  '$', 'Backbone', './ReactViewFactory', './template'
  './Models/Message/MessageBody/PlainTextBody'
  './Models/Message/Message'
], ($, Backbone, ReactViewFactory, MessageTemplate, MessageBody, Message) ->
  MessageModel = Backbone.Model.extend
    constructor: (attributes, options) ->
      @_message = new Message()
      @_message.setBody new MessageBody(attributes.body)
      @_message.setTitle(attributes.title)

      return @

    toJSON: ->
      title: @_message.getTitle()
      body: @_message.getBody().toHTML()

  MessageView = ReactViewFactory(MessageTemplate)

  $ () ->
    model = new MessageModel
      title: 'It works!'
      body: """
            Hello, World!
            I'm mighty glad to see you,
            the light, the trees and all the beautiful women.
            """

    view = new MessageView
      model: model
      el: '.message'

    view.render()



