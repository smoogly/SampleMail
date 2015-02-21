define ['inherit', 'assert'], (inherit, assert) ->
  inherit
    __constructor: (email) ->
      assert typeof email is 'string'
      @_email = email

    getEmail: -> @_email
