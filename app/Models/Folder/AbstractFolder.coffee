define (require) ->
  assert = require('assert')
  NotImplementedError = require('../../Error/NotImplementedError')

  require('inherit')
    __constructor: (mailbox, criterion) ->
      assert mailbox instanceof require('../Mailbox')
      assert criterion instanceof require('./Criterion/AbstractCriterion')
      return @

    getName: -> throw new NotImplementedError()
    getMessages: -> throw new NotImplementedError()
