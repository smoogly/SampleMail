require ['inherit'], (inherit) ->
  inherit Error,
    toString: -> "Method should be overridden by the successor class";


