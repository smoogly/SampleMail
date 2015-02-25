define (require, exports, module) ->
  assert = require('assert')
  Destination = require('./Message/Destination/EmailAddress')

  module.exports = require('inherit')
    __constructor: (email) ->
      assert typeof email is 'string'
      @_email = email
      @_messages = []
      return @

    getEmail: -> new Destination(@_email)
    isOwnAddress: (address) -> @getEmail().compare(address)

    getFolders: ->
      return @_folders if @_folders
      @_folders = [
        new (require('./Folder/Inbox'))(@),
        new (require('./Folder/Thrash'))(@)
      ]

    getMessages: -> @_messages
    addMessage: (message) ->
      assert message instanceof require('./Message/AbstractMessage')
      @_messages.push(message)
