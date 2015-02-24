define (require) ->
  MessageView = require('./Veiws/ReactView/ReactViewFactory')(require('./template'))

  MessageModel = require('inherit') require('./Models/BackboneProxyModelFactory')(require('./Models/Message/Message')),
    save: (attrs) ->
      @set(attrs)

      @getModel().setTitle(@get('title')) if @get('title')?
      PlainTextBody = require('./Models/Message/MessageBody/PlainTextBody')
      @getModel().setBody(new PlainTextBody(@get('body'))) if @get('body')?

      return @

  Mailbox = require('./Models/Mailbox')
  mailbox = new Mailbox('arseny@smoogly.ru')

  FolderList = require('./Models/BackboneFolderList')
  folderList = new FolderList(mailbox)

  FolderListView = require('./Veiws/FolderList/FolderList')
  folderListView = new FolderListView
    model: folderList


  require('$') () ->
    root = new (require('./Veiws/ReactView/ReactRootView'))
      el: '.message'

    folderView = new (require('./Veiws/ReactView/ReactCompositeView'))()

    folderView
      .append new MessageView
        model: new MessageModel().save
          title: 'It works!'
          body: """
                Hello, World!
                I'm mighty glad to see you,
                the light, the trees and all the beautiful women.
                """

      .append new MessageView
        model: new MessageModel().save
          title: 'Second one'
          body: """
                What if there was a nice way to stack views?
                """

      .append new MessageView
        model: new MessageModel().save
          title: 'Third one'
          body: """
                Oh, right, there is one.
                """

    logoView = new (require('./Veiws/Logo/Logo'))()

    root
      .append(logoView)
      .append(folderListView)
      .append(folderView)
      .render()



