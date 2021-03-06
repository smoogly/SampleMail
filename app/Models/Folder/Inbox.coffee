define [
  'inherit', 'assert'
  '../Mailbox'
  './AbstractFolder'
  './Criterion/AbstractCriterion'
  '../Message/Label/TrashLabel'
], (inherit, assert, Mailbox, AbstractFolder, AbstractCriterion, TrashLabel) ->

  inherit AbstractFolder,
    __constructor: (mailbox) ->
      @__base mailbox, new @__self.Criterion(mailbox)

    getName: -> 'Inbox'
  ,
    Criterion: inherit AbstractCriterion,
      __constructor: (mailbox) ->
        @_mailbox = mailbox
        return @__base.apply(@, arguments)

      _test: (message) ->
        recipients = message.getRecipients()
        toMe = recipients.length > 0 and recipients.some(@_mailbox.isOwnAddress.bind(@_mailbox))
        return toMe and not message.hasLabelByType(TrashLabel)
