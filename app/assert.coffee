define (require) ->
  inherit = require 'inherit'
  AssertionError = inherit Error,
    name: 'AssertionError'
    __constructor: (@message) ->
    toString: -> "#{ @name }: #{ @message }"

  assert = (assertion, message, Error) ->
    Error = Error or AssertionError
    throw new Error(message or 'Falsey assertion') if not assertion

  assert.AssertionError = AssertionError
  return assert
