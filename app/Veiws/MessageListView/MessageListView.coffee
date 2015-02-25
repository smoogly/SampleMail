define (require) ->
  MessageListItemView = require('../ReactView/ReactViewFactory') require('./MessageListItemTemplate')
  MessageListItem = require('inherit') require('../../Models/BackboneProxyModel'),
    __constructor: ->
      @__base.apply(@, arguments)
      @id = @getModel().getID()

      @set
        title: @getModel().getTitle()
        body: @getModel().getBody().toHTML()

      return @

  require('inherit') require('../ReactView/ReactCompositeView'),
    __constructor: () ->
      @__base.apply(@, arguments)

    render: ->
      messages = @model.getModel().getMessages()

      ((messageView) =>
        if not messages.some((message) -> message.id is messageView.getID())
          @remove messageView
      ) view for view in @getChildren()

      ((message) =>
        if not @getChildren().some((messageView) -> messageView.getID() is message.id)
          @append new MessageListItemView(model: new MessageListItem(message))
      ) message for message in messages

      @__base.apply(@, arguments)
  ,
    _getClassname: -> 'messagelist'
