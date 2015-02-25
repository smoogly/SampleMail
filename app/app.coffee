define (require) ->

  Message = require('./Models/Message/Message')
  MessageBody = require('./Models/Message/MessageBody/PlainTextBody')

  Mailbox = require('./Models/Mailbox')
  mailbox = new Mailbox('arseny@smoogly.ru')

  mailbox.addMessage(message) for message in [
    new Message().setBody(new MessageBody('Hello, World')).setTitle('It works!').to(mailbox.getEmail())
  ]

  FolderList = require('./Models/BackboneFolderList')
  folderList = new FolderList(mailbox)

  FolderListView = require('./Veiws/FolderList/FolderList')
  folderListView = new FolderListView
    model: folderList

  MessageList = require('./Models/BackboneProxyModel')
  MessageListView = require('./Veiws/MessageListView/MessageListView')

  messageListView = new MessageListView
    model: new MessageList mailbox.getFolders()[0]

  require('$') () ->
    root = new (require('./Veiws/ReactView/ReactRootView'))
      el: '#mailbox'

    root
      .append new (require('./Veiws/Logo/Logo'))()
      .append folderListView
      .append messageListView
      .render()
