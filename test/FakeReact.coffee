define (require) ->
  FakeReact = require('inherit')
    __constructor: ->
      @types = {}

      [
        'Element'
        'Class'
      ].forEach (type) =>
        @__self.generateCreatorMethod(@, type)

      @render = sinon.stub()
      return @

  ,
    generateCreatorMethod: (fakeReactInstance, type) ->
      Type = require('inherit')
        __constructor: () ->
          @_type = type

      fakeReactInstance.types[type] = Type # Save a static reference to type

      method = 'create' + type

      fakeReactInstance[method + 'Results'] = []
      fakeReactInstance[method] = sinon.stub()

      ((call) =>
        result = new Type()
        fakeReactInstance[method+'Results'].push(result)

        fakeReactInstance[method+'Result'] = result if call is 0

        fakeReactInstance[method]
          .onCall call
          .returns result
      ) i for i in [0..10]

  return FakeReact
