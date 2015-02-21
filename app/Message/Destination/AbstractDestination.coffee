rqeuire ['inherit', 'assert'], (inherit, assert) ->
  inherit
    __constructor: (address) ->
      assert typeof address is 'string'
      @_address = address
