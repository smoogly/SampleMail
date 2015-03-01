define ['inherit', 'assert', '../../../Error/NotImplementedError'], (inherit, assert, NotImplementedError) ->
  AbstractLabel = inherit
    getType: -> @__self.getType()

  ,
    getType: -> throw new NotImplementedError()

    serialize: (label) ->
      assert label instanceof AbstractLabel
      JSON.stringify type: label.getType()

  return AbstractLabel
