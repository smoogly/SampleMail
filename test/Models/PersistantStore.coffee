define (require) ->
  describe 'PersistentStore', ->
    beforeEach ->
      @sinon = sinon.sandbox.create()

      @PS = require('../../../../build/app/Models/PersistentStore')

      @typeName = 'tn'
      @Type = require('inherit') {}
      @typeFactory = @sinon.stub()
      @typeSerializer = @sinon.stub()

      @ps = new @PS(@typeName, @Type, @typeFactory, @typeSerializer)

    afterEach ->
      @sinon.restore()

    describe 'constructor', ->
      it 'should throw if typeName is not a string', ->
        expect => new @PS(123123123, @Type, @typeFactory, @typeSerializer)
        	.to.throwError (err) ->
            expect err.message
              .to.be 'Type name should be a string'

      it 'should throw if typeName contains a type-id separator', ->
        separator = @PS.TYPE_ID_SEPARATOR
        invalidName = @typeName + separator + @typeName
        expect => new @PS(invalidName, @Type, @typeFactory, @typeSerializer)
          .to.throwError (err) ->
            expect err.message
              .to.be "Type name should not contain #{separator}"

      it 'should throw if Type is not a constructor', ->
        expect => new @PS(@typeName, false, @typeFactory, @typeSerializer)
          .to.throwError (err) ->
            expect err.message
              .to.be 'Type should be a constructor'

      it 'should throw if typeFactory is not a function', ->
        expect => new @PS(@typeName, @Type, true, @typeSerializer)
          .to.throwError (err) ->
            expect err.message
              .to.be 'TypeFactory should be a factory method to generate Type instance'

      it 'should throw if typeSerializer is not a function', ->
        expect => new @PS(@typeName, @Type, @typeFactory, 'nope')
          .to.throwError (err) ->
            expect err.message
              .to.be 'TypeSerializer should be a method to serialize Type to a string'

    describe 'static', ->
      beforeEach ->
        @LS = window.localStorage
        @sinon.stub window.localStorage, 'setItem'
        @sinon.stub window.localStorage, 'getItem'

      describe 'persist', ->
        beforeEach ->
          @key = 'key'
          @value = 'value'

        it 'should throw if key is not a string', ->
          expect => @PS.persist(123123, @value)
          	.to.throwError (err) ->
              expect err.message
              	.to.be 'Key should be a string'

        it 'should throw if key is empty', ->
          expect => @PS.persist('', @value)
            .to.throwError (err) ->
              expect err.message
                .to.be 'Key should be a string'

        it 'should throw if value is not a string', ->
          expect => @PS.persist(@key, 354654321)
            .to.throwError (err) ->
              expect err.message
                .to.be 'Value should be a string'

        it 'should return what LS.setItem returns', ->
          expected = {}
          @LS.setItem.returns expected

          expect @PS.persist(@key, @value)
          	.to.be expected

        it 'should return null if LS.setItem throws', ->
          @LS.setItem.throws(new Error('Nuh-uh!'))
          expect @PS.persist(@key, @value)
            .to.be null

        it 'should call LS.setItem with given key and value', ->
          @PS.persist(@key, @value)
          expect @LS.setItem.calledOnce
          	.to.be true

          expect @LS.setItem.calledWithExactly(@key, @value)
            .to.be true

      describe 'retrieve', ->
        beforeEach ->
          @key = 'key'

        it 'should throw if key is not a string', ->
          expect => @PS.retrieve(123123)
            .to.throwError (err) ->
              expect err.message
                .to.be 'Key should be a string'

        it 'should throw if key is empty', ->
          expect => @PS.retrieve('')
            .to.throwError (err) ->
              expect err.message
                .to.be 'Key should be a string'

        it 'should return null if LS.getItem throws', ->
          @LS.getItem.throws(new Error('Nuh-uh!'))
          expect @PS.retrieve(@key)
            .to.be null

        it 'should call LS.getItem with given key', ->
          @PS.retrieve(@key)
          expect @LS.getItem.calledOnce
          	.to.be true

          expect @LS.getItem.calledWithExactly @key
            .to.be true

        it 'should return what LS.getItem returns', ->
          expected = {}
          @LS.getItem.returns expected
          expect @PS.retrieve(@key)
          	.to.be expected

    describe 'getKey', ->
      it 'should return a typeName and id divided by a separator', ->
        id = 'blahblah'
        expect @ps.getKey id
        	.to.be @typeName + @PS.TYPE_ID_SEPARATOR + id

    describe 'put', ->
      beforeEach ->
        @id = 'id'
        @item = new @Type()

        @sinon.stub @ps, 'getKey'
        @sinon.stub @ps, '_putID'
        @sinon.stub @PS, 'persist'

      it 'should throw if item is not of a given Type', ->
        typeName = @typeName
        wrongItem = new (->)()

        expect => @ps.put @id, wrongItem
        	.to.throwError (err) ->
            expect err.message
            	.to.be "#{typeName} instance expected"

      it 'should call serializer with the item', ->
        @ps.put @id, @item
        expect @typeSerializer.calledOnce
          .to.be true
        
        expect @typeSerializer.calledWithExactly(@item)
        	.to.be true

      it 'should call getKey with the given id', ->
        @ps.put @id, @item
        expect @ps.getKey.calledOnce
          .to.be true

        expect @ps.getKey.calledWithExactly(@id)
          .to.be true

      it 'should call persist method with a key and a serialized value', ->
        serialized = {}
        @typeSerializer.returns serialized

        key = {}
        @ps.getKey.returns key

        @ps.put @id, @item
        expect @PS.persist.calledOnce
          .to.be true

        expect @PS.persist.calledWithExactly(key, serialized)
        	.to.be true

      it 'should call _putID with the given id', ->
        @ps.put @id, @item
        expect @ps._putID.calledOnce
          .to.be true

        expect @ps._putID.calledWithExactly(@id)
        	.to.be true

    describe 'fetch', ->
      beforeEach ->
        @id = 'whaba-daba-doo'

        @sinon.stub @ps, 'getKey'

        @retrieved = {}
        @sinon.stub @PS, 'retrieve'
          .returns @retrieved

      it 'should call getKey with the given id', ->
        @ps.fetch @id
        expect @ps.getKey.calledOnce
          .to.be true

        expect @ps.getKey.calledWithExactly(@id)
          .to.be true

      it 'should call retrieve method with a key from getKey', ->
        key = {}
        @ps.getKey.returns key

        @ps.fetch @id

        expect @PS.retrieve.calledOnce
        	.to.be true

        expect @PS.retrieve.calledWithExactly(key)
        	.to.be true

      it 'should run factory with a retrieved value', ->
        @ps.fetch @id
        expect @typeFactory.calledOnce
        	.to.be true

        expect @typeFactory.calledWithExactly(@retrieved)
          .to.be true

      it 'should return the serialization result', ->
        item = {}
        @typeFactory.returns item

        expect @ps.fetch @id
          .to.be item

