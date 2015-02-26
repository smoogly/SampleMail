define [
  'inherit'
  './AbstractFolder'
  './Criterion/AbstractCriterion'
  '../Message/Label/TrashLabel'
], (inherit, AbstractFolder, AbstractCriterion, TrashLabel) ->
  inherit AbstractFolder,
    __constructor: (mailbox) ->
      @__base mailbox, new @__self.Criterion()

    getName: -> 'Trash'
  ,
    Criterion: inherit AbstractCriterion,
      _test: (message) ->
        message.hasLabelByType(TrashLabel)


