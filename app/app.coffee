define [
  '_', '$', './Models/BackboneProxyFactory'
  './Veiws/ReactView/ReactViewFactory'
  './Veiws/ReactView/ReactRootView'
  './template'
  './Models/Message/MessageBody/PlainTextBody'
  './Models/Message/Message'
], (_, $, ModelProxyFactory, ReactViewFactory, RootView, MessageTemplate, MessageBody, Message) ->

  MessageView = ReactViewFactory(MessageTemplate)
  MessageModel = require('inherit') ModelProxyFactory(Message),
    save: (attrs) ->
      @set(attrs)

      @getModel().setTitle(@get('title')) if @get('title')?
      @getModel().setBody(new MessageBody(@get('body'))) if @get('body')?

      return @

  $ () ->
    root = new RootView
      el: '.message'

    root
      .append new MessageView
        model: new MessageModel().save
          title: 'It works!'
          body: """
                Hello, World!
                I'm mighty glad to see you,
                the light, the trees and all the beautiful women.
                """

      .append new MessageView
        model: new MessageModel().save
          title: 'Second one'
          body: """
                What if there was a nice way to stack views?
                """

      .append new MessageView
        model: new MessageModel().save
          title: 'Third one'
          body: """
                Oh, right, there is one.
                """

      .render()



