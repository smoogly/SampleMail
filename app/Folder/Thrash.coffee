require [
  'inherit'
  'AbstractFolder.coffee'
  'Criterion/AbstractCriterion.coffee'
  '../Message/Label/ThrashLabel.coffee'
], (inherit, AbstractFolder, AbstractCriterion, ThrashLabel) ->
  InThrashCriterion = inherit AbstractCriterion,
    _test: (message) ->
      message.hasLabelByType(ThrashLabel)

  inherit AbstractFolder,
    constructor: ->
      super new InThrashCriterion()


