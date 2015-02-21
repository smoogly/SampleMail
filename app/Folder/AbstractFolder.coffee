require [
  'inherit', 'assert'
  'Criterion/AbstractCriterion.coffee'
  '../Error/NotImplementedError.coffee'
], (inherit, assert, AbstractCriterion, NotImplementedError) ->
  inherit
    _build: (criterion) -> throw new NotImplementedError
    __constructor: (criterion) ->
      assert criterion instanceof AbstractCriterion
      @_build(criterion)
