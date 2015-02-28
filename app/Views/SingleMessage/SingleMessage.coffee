define (require) ->
  require('inherit') require('../ReactView/ReactViewFactory')(require('./SingleMessageTemplate')),
    _getClassHooks: ->
      that = @
      require('_').extend @__base.apply(@, arguments),
        toTrash: ->
          that.model.getModel().toTrash()
          that.trigger that.__self.TRASHED_EVENT

  ,
    TRASHED_EVENT: 'message-trashed'

