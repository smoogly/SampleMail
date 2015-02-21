define (require) ->
  inherit = require 'inherit'
  AssertionError = inherit Error,
    __constructor: (@_msg) ->
    toString: -> "AssertionError: #{ @_msg }"

  (assertion, message) ->
    throw new AssertionError(message or 'Falsey assertion') if not assertion
