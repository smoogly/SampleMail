define (require) ->
  assert = require('assert')
  AbstractFolder = require('./AbstractFolder')

  require('inherit') require('Backbone').Model,
    __constructor: (folder) ->
      assert folder instanceof AbstractFolder, 'Folder instance expected'
      @_folder = folder
      return @__base.apply(@)

    getFolder: -> @_folder
    save: ->



