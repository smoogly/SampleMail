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

      it 'should not call React.render on subsequent calls', ->
        #We're already attached to the dom with given children, no need to reattach
        @instance.render()
        @instance.render()
        @instance.render()
        expect @fakeReact.render.calledOnce
        	.to.be true

      it 'should emit a change event if children have changed', ->
        sinon.stub @instance, 'isChanged'
          .returns true

        sinon.stub @instance, 'trigger'

        @instance.render()

        expect @instance.trigger.calledOnce
          .to.be true

        expect @instance.trigger.calledWithExactly(@Successor.ONCHANGE_EVENT_NAME)

    describe '_getClassHooks', ->
      beforeEach ->
        @FakeReactClass = require('inherit') @instance._getClassHooks()

        @fakeReactClass = new @FakeReactClass()
        @fakeReactClass.forceUpdate = sinon.stub()

      describe 'onChange', ->
        it 'should call foceUpdate', ->
          @fakeReactClass.onChange()
          expect @fakeReactClass.forceUpdate.calledOnce
            .to.be true
