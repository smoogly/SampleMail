define [
  '$', 'Backbone'
  './Veiws/ReactView/ReactViewFactory'
  './Veiws/ReactView/ReactRootView'
  './template'
  './Models/Message/MessageBody/PlainTextBody'
  './Models/Message/Message'
], ($, Backbone, ReactViewFactory, RootView, MessageTemplate, MessageBody, Message) ->
  MessageModel = Backbone.Model.extend
    constructor: (attributes) ->
      @_message = new Message()
      @_message.setBody new MessageBody(attributes.body)
      @_message.setTitle(attributes.title)

      return @

    toJSON: ->
      title: @_message.getTitle()
      body: @_message.getBody().toHTML()

  MessageView = ReactViewFactory(MessageTemplate)

  $ () ->
    root = new RootView
      el: '.message'

    root
      .append new MessageView
        model: new MessageModel
          title: 'It works!'
          body: """
                Hello, World!
                I'm mighty glad to see you,
                the light, the trees and all the beautiful women.
                """

      .append new MessageView
        model: new MessageModel
          title: 'Second one'
          body: """
                What if there was a nice way to stack views?
                """

      .append new MessageView
        model: new MessageModel
          title: 'Third one'
          body: """
                Oh, right, there is one.
                """

      .render()



