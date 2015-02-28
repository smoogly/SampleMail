define (require) ->
  ###*
  # This composite view is the only React View
  # capable of actually rendering html
  #
  # It should be used as a topmost view
  # to represent a separate chunk of application,
  # either a whole application or a single layout or a page of some kind
  #
  # Another use is to build independent areas on a single page.
  ###
  require('inherit') require('./ReactCompositeView'),
    render: ->
      @trigger(@__self.ONCHANGE_EVENT_NAME) if @isChanged()

      if not @_isAttached
        @.__self._getReact().render(@__base.apply(@, arguments), @el)
        @_isAttached = yes
