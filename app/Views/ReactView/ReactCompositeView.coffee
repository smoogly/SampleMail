define (require) ->
  assert = require 'assert'
  ReactCompositeView = require('inherit') [require('../AbstractView/AbstractCompositeView'), require('./ReactCommonMix')],
    __constructor: (attrs) ->
      @__base.apply(@, arguments)

      @setModel(attrs?.model)
      @on(@__self.MODEL_CHANGE_EVENT_NAME, @onModelChange, @)

      return @

    append: (view) ->
      assert view instanceof require('./AbstractReactView') or view instanceof ReactCompositeView, 'Only React Views may be appended to a React Composite View'
      # TODO: fix throwing when ReactRootView is being attached. There's a circular reference with ReactRootView now.
      # assert view not instanceof require('./ReactRootView'), 'Root views are not rendered into React.elements and should not be appended'
      @__base.apply @, arguments

    render: ->
      # Re-render children
      @__base.apply @, arguments

      # Return the cached element
      return @_element if @_element

      # Create and return a new element containing child elements
      @_element = @.__self._getReact().createElement @_getClass()

    _getClassHooks: ->
      classSpec = @__base.apply(@, arguments)

      that = @
      classSpec.render = ->
        children = that.getChildren()

        keyedViews = require('_').zipObject(
          children.map((child) -> child.getID()),
          children.map((child) -> child.render())
        ) if children.length

        return that.__self._getReact().createElement(
          that.__self._getTag(),
          className: that.__self._getClassname(),
          keyedViews
        )

      return classSpec

    onModelChange: ->
      @render()

  ,
    _getTag: -> 'div'
    _getClassname: -> ''

  ReactCompositeView
