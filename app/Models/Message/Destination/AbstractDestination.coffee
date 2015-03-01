define ['inherit', 'assert'], (inherit, assert) ->
  AbstractDestination = inherit
    __constructor: (address) ->
      assert typeof address is 'string'
      @_address = address
      return @

    getAddress: -> @_address

    compare: (destination) ->
      assert destination instanceof @__self
      return destination.getAddress() is @getAddress()

  ,
    serialize: (destination) ->
      assert destination instanceof AbstractDestination

      JSON.stringify address: destination.getAddress()

  return AbstractDestination
