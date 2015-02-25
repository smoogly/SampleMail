define (require) ->
  assert = require('assert')
  NotImplementedError = require('../../Error/NotImplementedError')

  require('inherit')
    __constructor: (mailbox, criterion) ->
      assert mailbox instanceof require('../Mailbox')
      assert criterion instanceof require('./Criterion/AbstractCriterion')

      @_mailbox = mailbox
      @_criterion = criterion

      return @

    getName: -> throw new NotImplementedError()

    getMessages: ->
      @_mailbox.getMessages().filter (message) => @_criterion.test(message)
