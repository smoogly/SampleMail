define (require) ->
  describe 'AbstractCompositeView', ->
    beforeEach ->
      @AbstractView = require '../../../../../build/app/Views/AbstractView/AbstractView'
      @AbstractCompositeView = require '../../../../../build/app/Views/AbstractView/AbstractCompositeView'

      @CompositeSuccessor = require('inherit') @AbstractCompositeView
      @composite = new @CompositeSuccessor()

      @ViewSuccessor = require('inherit') @AbstractView
      @view = new @ViewSuccessor()

    describe 'Constructor', ->
      it 'should create an instance of AbstractView', ->
        expect @composite
        	.to.be.an @AbstractView

    describe 'append', ->
      it 'should throw if argument is not an instance of view', ->
        expect => @composite.append 'nope'
        .to.throwError (err) ->
          expect err.message
          .to.be 'AbstractView instance required'

      it 'should throw when attempting to append itself', ->
        expect => @composite.append @composite
        	.to.throwError (err) ->
            expect err.message
              .to.be 'Can not append Composite View to itself'

      it 'should throw when attempting to append a view twice', ->
        @composite.append @view
        expect => @composite.append @view
        	.to.throwError (err) ->
            expect err.message
            	.to.be 'Appended view is already a child of this composite'


      it 'should not throw if argument is an instance of Composite View', ->
        expect => @composite.append new @CompositeSuccessor()
          .to.not.throwError()

      it 'should return the composite for chaining', ->
        expect @composite.append @view
          .to.be @composite

      it 'should add the view to children list', ->
        expect @composite.append(@view).getChildren()
        	.to.contain @view

      it 'should call setChanged', ->
        sinon.stub @composite, 'setChanged'
        @composite.append @view
        expect @composite.setChanged.calledOnce
        	.to.be true

    describe 'remove', ->
      it 'should throw if argument is not an instance of view', ->
        expect => @composite.remove 'nope'
        	.to.throwError (err) ->
            expect err.message
              .to.be 'AbstractView instance required'

      it 'should throw if argument is not a child', ->
        expect => @composite.remove new @ViewSuccessor()
        	.to.throwError (err) ->
            expect err.message
            	.to.be 'View is not a child'

      it 'should remove the view from the children list', ->
        @composite.append @view
        @composite.remove @view

        expect @composite.getChildren()
        	.to.not.contain @view

      it 'should call setChanged', ->
        sinon.stub @composite, 'setChanged'

        @composite.append @view
        @composite.remove @view

        expect @composite.setChanged.calledTwice #once by append, once by remove
        	.to.be true

    describe 'removeAllChildren', ->
      it 'should leave no children', ->
        @composite.append @view
        @composite.removeAllChildren()
        expect @composite.getChildren().length
        	.to.be 0

    describe 'render', ->
      beforeEach ->
        @children = [
          new @ViewSuccessor()
          new @ViewSuccessor()
          new @ViewSuccessor()
        ]

        @expectedResults = []
        @children.forEach (child) =>
          renderResult = {}
          @expectedResults.push renderResult
          sinon.stub child, 'render'
            .returns renderResult

        sinon.stub @composite, 'getChildren'
          .returns @children

      it 'should return a list', ->
        expect @composite.render()
          .to.be.an Array

      it 'should return a list of child render results', ->
        results = @composite.render()
        @expectedResults.forEach (expectedResult) ->
          expect results
            .to.contain expectedResult

      it 'should match the result order with children order', ->
        results = @composite.render()
        expect results[index]
          .to.be expectedResult for expectedResult, index in @expectedResults

      it 'should call setRendered', ->
        sinon.stub @composite, 'setRendered'
        @composite.render()

        expect @composite.setRendered.calledOnce
        	.to.be true

      it 'should call isChanged once', ->
        sinon.stub @composite, 'isChanged'
        @composite.render()

        expect @composite.isChanged.calledOnce
        	.to.be true

      it 'should call isChanged before setRendered', ->
        sinon.stub @composite, 'setRendered'
        sinon.stub @composite, 'isChanged'
        @composite.render()
        expect @composite.setRendered.calledAfter @composite.isChanged
          .to.be true

      it 'should emit a change event if isChanged returns true', ->
        sinon.stub @composite, 'trigger'
        sinon.stub @composite, 'isChanged'
          .returns true

        @composite.render()
        expect @composite.trigger.calledOnce
        	.to.be true

        expect @composite.trigger.calledWithExactly(@CompositeSuccessor.ONCHANGE_EVENT_NAME)
        	.to.be true

      it 'should not emit if isChanged returns false', ->
        sinon.stub @composite, 'trigger'
        sinon.stub @composite, 'isChanged'
          .returns false

        @composite.render()
        expect @composite.trigger.called
          .to.be false

    describe 'isChanged', ->
      it 'should return false for a new Composite', ->
        expect @composite.isChanged()
        	.to.be false

      it 'should return true if setChanged was called', ->
        @composite.setChanged()
        expect @composite.isChanged()
        	.to.be true

      it 'should return false if setRendered was called after setChanged', ->
        @composite.setChanged()
        @composite.setRendered()
        expect @composite.isChanged()
          .to.be false




