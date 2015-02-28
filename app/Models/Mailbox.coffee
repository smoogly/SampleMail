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
        new (require('./Folder/Trash'))(@),
        new (require('./Folder/Sent'))(@)
      ]

    getMessages: -> @_messages
    addMessage: (message) ->
      assert message instanceof require('./Message/AbstractMessage'), 'Message expected'
      @_messages.push(message)

    getMessageByID: (id) ->
      assert id and typeof id is 'string', 'Message id should be a string'
      message = require('_').find @getMessages(), (message) -> message.getID() is id

      throw new @__self.UnknownMessageError unless message
      return message

  ,
      UnknownMessageError: require('inherit') assert.AssertionError,
        name: 'UnknownMessageError'
