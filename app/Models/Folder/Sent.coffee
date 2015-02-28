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

    getName: -> 'Sent'
  ,
    Criterion: inherit AbstractCriterion,
      __constructor: (mailbox) ->
        @_mailbox = mailbox
        return @__base.apply(@, arguments)

      _test: (message) ->
        return @_mailbox.isOwnAddress(message.getFrom()) and
            not message.hasLabelByType(TrashLabel)
