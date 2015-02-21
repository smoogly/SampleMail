rqeuire ['inherit', 'assert'], (inherit, assert) ->
  inherit
    constructor: (address) ->
      assert typeof address is 'string'
      @_address = address
