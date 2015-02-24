define (require, exports, module) ->
  assert = require('assert')

  module.exports = require('inherit')
    __constructor: (email) ->
      assert typeof email is 'string'
      @_email = email
      @_messages = []
      return @

    getEmail: -> @_email
    isOwnAddress: (address) -> @_email is address

    getFolders: ->
      return @_folders if @_folders
      @_folders = [
        new (require('./Folder/Inbox'))(@)
        new (require('./Folder/Thrash'))(@)
      ]
