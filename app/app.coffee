define (require) ->
  Destination = require('./Models/Message/Destination/EmailAddress')
  Message = require('./Models/Message/Message')
  MessageBody = require('./Models/Message/MessageBody/PlainTextBody')
  TrashLabel = require('./Models/Message/Label/TrashLabel')
  Mailbox = require('./Models/Mailbox')

  FolderList = require('./Models/BackboneFolderList')
  FolderListView = require('./Views/FolderList/FolderList')

  MessageList = require('./Models/BackboneProxyModel')
  MessageListView = require('./Views/MessageListView/MessageListView')

  SampleMail = require('inherit') require('./Views/ReactView/ReactRootView'),
    __constructor: ->
      @__base.apply(@, arguments)

      @_mailbox = new Mailbox('arseny@smoogly.ru')
      @_fakePopulateMailbox()

      @_folderList = new FolderList(@_mailbox)
      @_folderListView = new FolderListView
        model: @_folderList

      @_folderList.on FolderList.CHANGE_FOLDER_EVENT, @_onCurrentFolderChange.bind(@)

      @_messageListView = new MessageListView
        model: new MessageList @_mailbox.getFolders()[0]



      @_initRouter()
      @_appendViews()

      return @

    _fakePopulateMailbox: ->
      @_mailbox.addMessage(message) for message in [
        # Inbox
        new Message()
          .setBody(new MessageBody('Hello, World'))
          .setTitle('It works!')
          .to(@_mailbox.getEmail())
          .from(new Destination('wherever'))

        new Message()
          .setBody(new MessageBody(
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
          .to(@_mailbox.getEmail())
          .from(new Destination('lorem@lipsum.org'))


        #Trash
        new Message()
          .setTitle('Spam-spam-spam')
          .setBody(new MessageBody('Enlarge your penis in twelve easy steps'))
          .to(@_mailbox.getEmail())
          .addLabel(new TrashLabel())
          .from(new Destination('whatever@mailforspam.com'))

        #Sent
        new Message()
          .setTitle('Re: a conversation')
          .setBody(new MessageBody(
            """
            Dunno, how about a movie?
            >Depends, what'd you have planned?
            >>Wanna meet saturday?
            """
          ))
          .to(new Destination('SteveBallmer@microsoft.com'))
          .from(@_mailbox.getEmail())

        #No drafts
      ]

    _onCurrentFolderChange: (folderName) ->
      try
        currentFolder = @_folderList.getFolderByName(folderName)
      catch error
        throw error unless error instanceof FolderList.UnknownFolderError
        currentFolder = @_folderList.getFolderByName('Inbox')

      @_folderList.setCurrentFolder(currentFolder)
      @_folderList.save()
      @_router.navigate('/' + folderName);

      @_messageListView.setModel(new MessageList(
        @_folderList
        .getCurrentFolder()
        .getFolder()
      ))
      @_messageListView.trigger('change')

    _appendViews: ->
      Row = require('inherit') require('./Views/ReactView/ReactCompositeView'), {},
        _getClassname: -> 'row'

      @
        .append new (require('./Views/Logo/Logo'))()
        .append new Row()
          .append @_folderListView
          .append @_messageListView

    _initRouter: ->
      Router = require('inherit') require('Backbone').Router,
        routes:
          ':folder': 'folder'
          'message/:id': 'message'

      @_router = new Router()
      @_router.on 'route:folder', (folderName) =>
        @_onCurrentFolderChange(folderName)

      require('Backbone').history.start()


  require('$') () ->
    mail = new SampleMail
      el: '#mailbox'

    mail.render()
