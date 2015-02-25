define [
  'inherit'
  './AbstractFolder'
  './Criterion/AbstractCriterion'
  '../Message/Label/ThrashLabel'
], (inherit, AbstractFolder, AbstractCriterion, ThrashLabel) ->
  inherit AbstractFolder,
    __constructor: (mailbox) ->
      @__base mailbox, new @__self.Criterion()

    getName: -> 'Thrash'
  ,
    Criterion: inherit AbstractCriterion,
      _test: (message) ->
        message.hasLabelByType(ThrashLabel)


