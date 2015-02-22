define (require) ->
  AbstractView = require('./AbstractView')
  assert = require 'assert'

  require('inherit') AbstractView,
    __constructor: () ->
      @__base.apply @, arguments
      @_children = []
      return @

    append: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      assert subview isnt @, 'Can not append Composite View to itself'
      assert @getChildren().indexOf(subview) is -1, 'Appended view is already to this composite'

      @_children.push(subview)
      subview.once 'destroy', => @_forget subview
      return @

    _forget: (subview) ->
      index = @_children.indexOf subview
      assert index > -1
      @_children.splice index, 1

    getChildren: -> @_children

    render: ->
      return require '_'
        .map @_children, (child) ->
          child.render()
