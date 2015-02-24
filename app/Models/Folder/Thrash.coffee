define [
  'inherit'
  './AbstractFolder'
  './Criterion/AbstractCriterion'
  '../Message/Label/ThrashLabel'
], (inherit, AbstractFolder, AbstractCriterion, ThrashLabel) ->
  InThrashCriterion = inherit AbstractCriterion,
    _test: (message) ->
      message.hasLabelByType(ThrashLabel)

  inherit AbstractFolder,
    __constructor: (mailbox) ->
      @__base mailbox, new InThrashCriterion()

    getName: -> 'Thrash'


