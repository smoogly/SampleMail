define (require) ->
  inherit = require 'inherit'
  AssertionError = inherit Error,
    name: 'AssertionError'
    __constructor: (@message) ->
    toString: -> "#{ @name }: #{ @message }"

  (assertion, message) ->
    throw new AssertionError(message or 'Falsey assertion') if not assertion
