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
      assert not @isChild(subview), 'Appended view is already a child of this composite'
      assert subview isnt @, 'Can not append Composite View to itself'

      @_children.push(subview)
      @listenTo subview, 'destroy', => @remove subview

      @setChanged()

      return @

    remove: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      assert @isChild(subview), 'View is not a child'

      @_children.splice(@getChildren().indexOf(subview), 1)

      @setChanged()

      return @_children

    removeAllChildren: ->
      @remove(@_children[0]) while @_children.length > 0
      return @

    getChildren: -> @_children

    isChild: (subview) ->
      assert subview instanceof AbstractView, 'AbstractView instance required'
      return @getChildren().indexOf(subview) > -1

    render: ->
      @trigger(@__self.ONCHANGE_EVENT_NAME) if @isChanged()

      @setRendered()
      return require '_'
        .map @getChildren(), (child) ->
          child.render()

    setRendered: -> @_changed = false
    setChanged: -> @_changed = true
    isChanged: -> @_changed
