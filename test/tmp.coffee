define (require) ->
  describe 'Basic tests', ->
    it 'should just work', ->
      expect true
        .to.be true

    it 'should work with require', ->
      expect typeof require('assert')
        .to.be 'function'
