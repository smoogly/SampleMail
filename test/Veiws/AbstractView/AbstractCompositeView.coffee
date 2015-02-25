define (require) ->
  describe 'AbstractCompositeView', ->
    beforeEach ->
      @AbstractView = require '../../../../../build/app/Veiws/AbstractView/AbstractView'
      @AbstractCompositeView = require '../../../../../build/app/Veiws/AbstractView/AbstractCompositeView'

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
            	.to.be 'Appended view is already to this composite'


      it 'should not throw if argument is an instance of Composite View', ->
        expect => @composite.append new @CompositeSuccessor()
          .to.not.throwError()

      it 'should return the composite for chaining', ->
        expect @composite.append @view
          .to.be @composite

      it 'should add the view to children list', ->
        expect @composite.append(@view).getChildren()
        	.to.contain @view

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




