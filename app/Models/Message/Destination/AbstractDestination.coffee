define ['inherit', 'assert'], (inherit, assert) ->
  inherit
    __constructor: (address) ->
      assert typeof address is 'string'
      @_address = address
      return @

    getAddress: -> @_address

    compare: (destination) ->
      assert destination instanceof @__self
      return destination.getAddress() is @getAddress()
