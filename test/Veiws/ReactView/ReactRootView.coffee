define (require) ->
  describe 'ReactRootView', ->
    beforeEach ->
      @Successor = require('inherit') require('../../../../../build/app/Views/ReactView/ReactRootView')
      @instance = new @Successor()
      @instance.el = @el = {}

      @ReactCompositeView = require('../../../../../build/app/Views/ReactView/ReactCompositeView')

      @fakeReact = new (require('../../FakeReact'))()
      sinon.stub @Successor, '_getReact'
        .returns @fakeReact

    describe 'Constructor', ->
      it 'should create instances of ReactCompositeView', ->
        expect @instance
          .to.be.a @ReactCompositeView

    describe 'render', ->
      beforeEach ->
        @instance.render()

      it 'should call React.render once', ->
        expect @fakeReact.render.calledOnce
        	.to.be true

      it 'should call React.render with a React Element', ->
        expect @fakeReact.render.firstCall.args[0]
          .to.be.a @fakeReact.types.Element

      it "should call React.render with the view's current el node", ->
        expect @fakeReact.render.firstCall.args[1]
        	.to.be @el

      # Testing for a base method, this seems good enough
      it 'should render child views', ->
        ReactView = require('inherit') require('../../../../../build/app/Views/ReactView/AbstractReactView')
        view = new ReactView()
        sinon.stub view, 'render'

        @instance.append(view).render()
        expect view.render.calledOnce
        	.to.be true


