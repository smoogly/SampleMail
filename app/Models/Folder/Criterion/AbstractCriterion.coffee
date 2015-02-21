define [
  'inherit'
  'assert'
  '../../Message/AbstractMessage'
  '../../../Error/NotImplementedError'
], (inherit, assert, AbstractMessage, NotImplementedError) ->
  inherit
    _test: (message) ->
      throw new NotImplementedError()

    ###*
    # Test whether a given Message passes the criterion
    #
    # @param {AbstractMessage} message    Message to test
    # @returns Boolean
    ###
    test: (message) ->
      assert message instanceof AbstractMessage
      @_test(message)
