define (require) ->
  require('inherit') require('../ReactView/ReactViewFactory')(require('./FolderListTemplate')),
    _getClassHooks: ->
      model = @model
      require('_').extend @__base.apply(@, arguments),
        setCurrent: (folderName) ->
          model.setCurrentFolder(model.getFolderByName(folderName))
          model.save()
