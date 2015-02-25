define (require) ->
  assert = require 'assert'
  ReactCompositeView = require('inherit') require('../AbstractView/AbstractCompositeView'),
    # TODO: bind events to the model, like in AbstractReactView

    append: (view) ->
      assert view instanceof require('./AbstractReactView') or view instanceof ReactCompositeView, 'Only React Views may be appended to a React Composite View'
      # TODO: fix throwing when ReactRootView is being attached. There's a circular reference with ReactRootView now.
      # assert view not instanceof require('./ReactRootView'), 'Root views are not rendered into React.elements and should not be appended'
      @__base.apply @, arguments

    getID: -> @_id or @_id = require('util').uuid() #TODO: test

    render: ->
      # Re-render children
      renderedChildren = @__base.apply @, arguments

      # Return the cached element
      return @_element if @_element

      keyedViews = require('_').zipObject(
        @getChildren().map((child) -> child.getID()),
        renderedChildren
      ) if @getChildren().length

      # Or create and return a new element containing child elements
      @_element = @.__self._getReact().createElement(
        @__self._getTag()
        className: @__self._getClassname()
        keyedViews
      )
  ,
    # Injection method for testing
    _getReact: -> require 'React'
    _getTag: -> 'div'
    _getClassname: -> ''

  ReactCompositeView
