define (require) ->
  describe 'AbstractReactView', ->
    beforeEach ->
      @Successor = require('inherit') require('../../../../../build/app/Views/ReactView/AbstractReactView')

      @id = {id: 1}
      @cid = {cid: 2}
      @uuid = {uuid: 3}

      sinon.stub require('util'), 'uuid'
        .returns @uuid

      @model = new (require('Backbone')).Model();
      @model.id = @id
      @model.cid = @cid

      @instance = new @Successor
        model: @model

      @template = sinon.stub()
      sinon.stub @instance, '_getTemplate'
        .returns @template

      @fakeReact = new (require('../../FakeReact'))()
      sinon.stub @Successor, '_getReact'
        .returns @fakeReact

    afterEach ->
      require('util').uuid.restore?()

    describe 'Constructor', ->
      it 'should create an instance of AbstractView', ->
        expect @instance
        .to.be.a require('../../../../../build/app/Views/AbstractView/AbstractView')

    describe 'getID', ->
      it 'should return model.id if it exists', ->
        expect @instance.getID()
        	.to.be @id

      it 'should return model.cid if it exists and there is no model.id', ->
        @model.id = undefined
        expect @instance.getID()
        	.to.be @cid

      it 'should return an uuid if both model.id and model.cid are not defined', ->
        @model.id = @model.cid = undefined

        expect @instance.getID()
        	.to.be @uuid

      it 'should return an uuid if there is no model defined', ->
        @instance.model = undefined
        expect @instance.getID()
          .to.be @uuid

      it 'should return same uuid on subsequent calls', ->
        @model = undefined #Make sure we're returning uuids
        require('util').uuid.restore()

        expect @instance.getID()
          .to.be @instance.getID()

    describe 'render', ->
      beforeEach ->
        @Class = {}
        sinon.stub @instance, '_getClass'
          .returns @Class

        @instance.render()

      it 'should call React.createElement once', ->
        expect @fakeReact.createElement.calledOnce
          .to.be true

      it 'should not call React.createElement on subsequent calls', ->
        @instance.render()
        @instance.render()
        @instance.render()
        @instance.render() #Enough? :)

        expect @fakeReact.createElement.calledOnce
          .to.be true

      it 'should create a React Element with class from _getClass', ->
        expect @fakeReact.createElement.calledWithExactly(@Class)
        	.to.be true

      it 'should return a React Element', ->
        expect @instance.render()
        	.to.be.a @fakeReact.types.Element

      it 'should return same element on next calls', ->
        expect @instance.render()
          .to.be @instance.render()

    describe '_getClass', ->
      beforeEach ->
        @hooks = {}
        sinon.stub @instance, '_getClassHooks'
          .returns @hooks

        @instance._getClass()

      it 'should call React.createClass once', ->
        expect @fakeReact.createClass.calledOnce
        	.to.be true

      it 'should create a React Class using a result of _getClassHooks', ->
        expect @fakeReact.createClass.calledWithExactly(@hooks)
        	.to.be true

      it 'should return a React Class', ->
        expect @instance._getClass()
        	.to.be.a @fakeReact.types.Class


