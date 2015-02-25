define (require) ->
  assert = require('assert')
  Mailbox = require('./Mailbox')
  AbstractFolder = require('./Folder/AbstractFolder')
  BackboneFolderModel = require('./Folder/BackboneFolderModel')

  require('inherit') require('./BackboneProxyModel'),
    __constructor: ->
      @__base.apply(@, arguments)

      @_folders = require('_') @getModel().getFolders()
        .indexBy (folder) -> folder.getName()
        .mapValues (folder) -> new BackboneFolderModel(folder)
        .valueOf()

      @save()
      return @

    _createModel: (mailbox) ->
      require('assert') mailbox instanceof Mailbox
      return mailbox # Pass the constructor argument

    save: ->
      @set
        folders: @getModel().getFolders().map (folder) -> folder.getName()
        currentFolder: @getCurrentFolder().getFolder().getName()

    getCurrentFolder: ->
      return @_currentFolder if @_currentFolder
      @_currentFolder = @_folders[@getModel().getFolders()[0].getName()];

    setCurrentFolder: (folder) ->
      assert folder instanceof AbstractFolder
      @_currentFolder = folder;

