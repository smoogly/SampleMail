define (require) ->

  Message = require('./Models/Message/Message')
  MessageBody = require('./Models/Message/MessageBody/PlainTextBody')
  TrashLabel = require('./Models/Message/Label/TrashLabel')

  Mailbox = require('./Models/Mailbox')
  mailbox = new Mailbox('arseny@smoogly.ru')

  mailbox.addMessage(message) for message in [
    # Inbox
    new Message()
      .setBody(new MessageBody('Hello, World'))
      .setTitle('It works!')
      .to(mailbox.getEmail())

    new Message().setBody(new MessageBody(
      """
      Lorem Ipsum is simply dummy text of the printing and typesetting industry.
      Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
      when an unknown printer took a galley of type and scrambled it to make a type specimen book.
      It has survived not only five centuries, but also the leap into electronic typesetting,
      remaining essentially unchanged. It was popularised in the 1960s with the release
      of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop
      publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      """
    ))
      .setTitle('Some long-ass title you\'ve got here, haven\'t you?')
      .to(mailbox.getEmail())


    #Trash
    new Message()
      .setTitle('Spam-spam-spam')
      .setBody(new MessageBody('Enlarge your penis in twelve easy steps'))
      .to(mailbox.getEmail())
      .addLabel(new TrashLabel())
  ]

  FolderList = require('./Models/BackboneFolderList')
  folderList = new FolderList(mailbox)

  FolderListView = require('./Views/FolderList/FolderList')
  folderListView = new FolderListView
    model: folderList

  MessageList = require('./Models/BackboneProxyModel')
  MessageListView = require('./Views/MessageListView/MessageListView')

  messageListView = new MessageListView
    model: new MessageList mailbox.getFolders()[0]

  folderList.on 'change:currentFolder', () ->
    messageListView.setModel(new MessageList(
      folderList
        .getCurrentFolder()
        .getFolder()
    ))
    messageListView.trigger('change')

  require('$') () ->
    root = new (require('./Views/ReactView/ReactRootView'))
      el: '#mailbox'


    Row = require('inherit') require('./Views/ReactView/ReactCompositeView'), {},
      _getClassname: -> 'row'

    root
      .append new (require('./Views/Logo/Logo'))()
      .append new Row()
        .append folderListView
        .append messageListView
      .render()
