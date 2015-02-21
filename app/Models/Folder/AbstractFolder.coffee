define [
  'inherit', 'assert'
  './Criterion/AbstractCriterion'
  '../../Error/NotImplementedError'
], (inherit, assert, AbstractCriterion, NotImplementedError) ->
  inherit
    _build: (criterion) -> throw new NotImplementedError
    __constructor: (criterion) ->
      assert criterion instanceof AbstractCriterion
      @_build(criterion)
      return @
