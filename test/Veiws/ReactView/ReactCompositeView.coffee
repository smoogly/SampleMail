define (require) ->
  describe 'ReactCompositeView', ->
    beforeEach ->
      @Successor = require('inherit') require('../../../../../build/app/Veiws/ReactView/ReactCompositeView')
      @instance = new @Successor()

      @AbstractReactView = require('inherit') require('../../../../../build/app/Veiws/ReactView/AbstractReactView')
      @ReactView = require('inherit') @AbstractReactView
      @view = new @ReactView()
      sinon.stub @view, 'render'

      @fakeReact = new (require('../../FakeReact'))()
      sinon.stub @Successor, '_getReact'
        .returns @fakeReact

      @RootView = require('../../../../../build/app/Veiws/ReactView/ReactRootView')

    describe 'Constructor', ->
      it 'should create an instance of AbstractView', ->
        expect @instance
          .to.be.a require('../../../../../build/app/Veiws/AbstractView/AbstractView')

    describe 'append', ->
      it 'should throw if argument is not a view', ->
        expect => @instance.append 'nope'
          .to.throwError (err) ->
            expect err.message
              .to.be 'Only React Views may be appended to a React Composite View'

      it 'should not throw if appending a ReactView', ->
        expect => @instance.append @view
        	.to.not.throwError()

      it 'should not throw if appending a ReactCompositeView', ->
        expect => @instance.append new @Successor()
          .to.not.throwError()

      # Disabled. See a TODO about a circular reference in ReactCompositeView
      xit 'should throw if appending an instance of a ReactRootView', ->
        expect => @instance.append new @RootView()
        	.to.throwError (err) ->
            expect err.message
              .to.be 'Root views are not rendered into React.elements and should not be appended'

      # Testing for a base method, this seems good enough
      it 'should put appended view to children list', ->
        @instance.append @view
        expect @instance.getChildren()
        	.to.contain @view

    describe 'render', ->
      beforeEach ->
        @instance.append @view
        sinon.spy @instance, 'render'
        @instance.render()


      it 'should render child views once', ->
        expect @view.render.calledOnce
        	.to.be true

      it 'should re-render child views on every call', ->
        @instance.render()
        @instance.render()
        @instance.render() # Gotta be enough

        # Check @view.render called as much as @instance.render
        expect @view.render.callCount
          .to.be @instance.render.callCount

      it 'should call React.createElement once', ->
        expect @fakeReact.createElement.calledOnce
          .to.be true

      it 'should call React.createElement to create a wrapper div', ->
        expect @fakeReact.createElement.calledWith('div', null)
          .to.be true

      it 'should not call React.createElement on subsequent calls', ->
        @instance.render()
        @instance.render()
        @instance.render()
        expect @fakeReact.createElement.calledOnce
        	.to.be true

      it 'should call React.createElement with a keyed hash of child views', ->
        id = 'Tests are ducking awesome!'
        view = new @ReactView()
        sinon.stub view, 'getID'
          .returns id

        renderedElement = {}
        sinon.stub view, 'render'
          .returns renderedElement

        instance = new @Successor()
        instance.append(view).render()
        expect @fakeReact.createElement.lastCall.args[2]
          .to.have.property id, renderedElement

      it 'should return a React Element', ->
        expect @instance.render()
          .to.be.a @fakeReact.types.Element

      it 'should return same React Element on subsequent calls', ->
        expect @instance.render()
          .to.be @instance.render()
