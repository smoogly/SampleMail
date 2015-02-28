define (require) ->
  MessageListItemView = require('inherit') require('../ReactView/ReactViewFactory')(require('./MessageListItemTemplate'))

  MessageListItem = require('inherit') require('../../Models/BackboneProxyModel'),
    __constructor: ->
      @__base.apply(@, arguments)
      @id = @getModel().getID()

      @set
        id: @getModel().getID()
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
        @append(new MessageListItemView(model: new MessageListItem(message)))

      @__base.apply(@, arguments)
  ,
    _getClassname: -> 'message-list col-xs-10'
    _getTag: -> 'ul'
