define (require) ->
  Mailbox = require('./Mailbox')
  require('inherit') require('./BackboneProxyModelFactory')(Mailbox),
    __constructor: ->
      @__base.apply(@, arguments)
      @save()
      return @

    _createModel: (mailbox) ->
      require('assert') mailbox instanceof Mailbox
      return mailbox # Pass the constructor argument

    save: ->
      @set folders: @getModel().getFolders().map (folder) -> folder.getName()
