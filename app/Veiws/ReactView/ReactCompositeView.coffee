define (require) ->
  assert = require 'assert'
  ReactCompositeView = require('inherit') require('../AbstractView/AbstractCompositeView'),
    append: (view) ->
      assert view instanceof require('./AbstractReactView') or view instanceof ReactCompositeView, 'Only React Views may be appended to a React Composite View'
      # TODO: fix throwing when ReactRootView is being attached. There's a circular reference with ReactRootView now.
      # assert view not instanceof require('./ReactRootView'), 'Root views are not rendered into React.elements and should not be appended'
      @__base.apply @, arguments

    render: ->
      # Re-render children
      renderedChildren = @__base.apply @, arguments

      # Return the cached element
      return @_element if @_element

      keyed = require('_').zipObject(
        @getChildren().map((child) -> child.getID()),
        renderedChildren
      )

      # Or create and return a new <div> containing child elements
      @_element = @.__self._getReact().createElement 'div', null, keyed
  ,
    # Injection method for testing
    _getReact: -> require 'React'

  ReactCompositeView
