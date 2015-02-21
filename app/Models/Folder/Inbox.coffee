define [
  'inherit'
  './AbstractFolder'
  './Criterion/AbstractCriterion'
], (inherit, AbstractFolder, AbstractCriterion) ->
  InboxCriterion = inherit AbstractCriterion,
    _test: (message) ->
      #TODO: Test whether message is not in thrash and is directed to this mailbox

  inherit AbstractFolder
    __constructor: ->
      @__base new InboxCriterion()

