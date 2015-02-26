define (require) ->
  AbstractView = require('./AbstractView')
  assert = require 'assert'

  require('inherit') AbstractView,
    __constructor: () ->
      @__base.apply @, arguments
      @_children = []
      @_changed = false
      return @

    append: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      assert subview isnt @, 'Can not append Composite View to itself'
      assert @_children.indexOf(subview) is -1, 'Appended view is already to this composite'

      @_children.push(subview)
      @listenTo subview, 'destroy', => @remove subview

      @setChanged()

      return @

    remove: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      index = @getChildren().indexOf(subview)

      assert index > -1, 'View is not a child'
      @_children.splice(index, 1)

      @setChanged()

      return @_children

    removeAllChildren: ->
      @_children.forEach (child) => @stopListening(child)
      @_children = []

    getChildren: -> @_children

    render: ->
      @setRendered()
      return require '_'
        .map @getChildren(), (child) ->
          child.render()

    setRendered: -> @_changed = false
    setChanged: -> @_changed = true
    isChanged: -> @_changed
