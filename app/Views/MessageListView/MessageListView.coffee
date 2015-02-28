define (require) ->
  MessageListItemView = require('inherit') require('../ReactView/ReactViewFactory')(require('./MessageListItemTemplate')),
    _getClassHooks: ->
      that = @
      require('_').extend @__base.apply(@, arguments),
        selectMessage: ->
          that.trigger MessageListItemView.OPEN_MESSAGE_EVENT, that.model.getModel().getID()

  ,
    OPEN_MESSAGE_EVENT: 'message-item-open'

  MessageListItem = require('inherit') require('../../Models/BackboneProxyModel'),
    __constructor: ->
      @__base.apply(@, arguments)
      @id = @getModel().getID()

      @set
        title: @getModel().getTitle()
        firstline: @getModel().getBody().getFirstLine()

      return @

  require('inherit') require('../ReactView/ReactCompositeView'),
    __constructor: ->
      @__base.apply(@, arguments)
      @onModelChange()
      return @

    onModelChange: ->
      @removeAllChildren()

      @model.getModel().getMessages().forEach (message) =>
        messageItemView = new MessageListItemView(model: new MessageListItem(message))

        @listenTo messageItemView, MessageListItemView.OPEN_MESSAGE_EVENT, (messageID) =>
          @trigger @__self.OPEN_MESSAGE_EVENT, messageID

        @append(messageItemView)

      @__base.apply(@, arguments)
  ,
    _getClassname: -> 'message-list col-xs-10'
    _getTag: -> 'ul'

    OPEN_MESSAGE_EVENT: 'openmessage'
