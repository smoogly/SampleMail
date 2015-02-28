define (require) ->
  CHANGE_FOLDER_EVENT = require('../../Models/BackboneFolderList').CHANGE_FOLDER_EVENT

  require('inherit') require('../ReactView/ReactViewFactory')(require('./FolderListTemplate')),
    _getClassHooks: ->
      model = @model
      require('_').extend @__base.apply(@, arguments),
        setCurrent: (folderName) ->
          model.trigger(CHANGE_FOLDER_EVENT, folderName);

