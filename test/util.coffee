define (require) ->
  describe 'Util', ->
    beforeEach ->
      @Util = require('../../../build/app/util')

    describe 'uuid', ->
      it 'should generate a uuid looking like RFC4122', ->
        expect ///
          [0-9a-f]{8}
          -
          [0-9a-f]{4}
          -4
          [0-9a-f]{3}
          -
          [89ab]
          [0-9a-f]{3}-
          [0-9a-f]{12}
        ///.test(@Util.uuid())
          .to.be true
