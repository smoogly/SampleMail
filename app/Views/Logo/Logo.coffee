define (require) ->
  require('inherit') require('../ReactView/ReactViewFactory')(require('./LogoTemplate')),
    _getClassHooks: ->
      that = @
      require('_').extend @__base.apply(@, arguments),
        logoclicked: ->
          that.trigger that.__self.CLICKED_EVENT

  ,
    CLICKED_EVENT: 'logo-clicked'
