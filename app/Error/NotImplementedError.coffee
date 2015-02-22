define ['inherit'], (inherit) ->
  inherit Error,
    name: 'NotImplementedError'
    message: 'Method should be overridden by the successor class'
    __constructor: -> @
    toString: -> "#{ @name }: #{ @message }";


