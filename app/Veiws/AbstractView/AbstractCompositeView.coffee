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
      assert @_children.indexOf(subview) is -1, 'Appended view is already to this composite'

      @_children.push(subview)
      subview.once 'destroy', => @remove subview
      return @

    remove: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      index = @getChildren().indexOf(subview)

      assert index > -1, 'View is not a child'
      @_children.splice(index, 1)

    getChildren: -> @_children

    render: ->
      return require '_'
        .map @getChildren(), (child) ->
          child.render()
