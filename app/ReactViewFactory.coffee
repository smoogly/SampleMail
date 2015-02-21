define ['Backbone', 'React'], (Backbone, React) ->
  (template) ->
    Backbone.View.extend
      _getElement: ->
        return @_reactElement if @_reactElement? #Singleton

        Class = React.createClass
          render: -> template.call(@)

        @_reactElement = React.createElement Class, @model.toJSON()

      render: ->
        element = @_getElement()
        @_component.setState(@model.toJSON()) if @_component?
        @_component = React.render(element, @el)
