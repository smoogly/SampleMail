require [
  'inherit'
  'AbstractFolder.coffee'
  'Criterion/AbstractCriterion.coffee'
], (inherit, AbstractFolder, AbstractCriterion) ->
  InboxCriterion = inherit AbstractCriterion,
    _test: (message) ->
      #TODO: Test whether message is not in thrash and is directed to this mailbox

  inherit AbstractFolder
    constructor: ->
      super new InboxCriterion()

