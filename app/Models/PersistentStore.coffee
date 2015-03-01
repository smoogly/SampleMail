define (require) ->
  assert = require('assert')
  LS = window.localStorage if 'localStorage' of window and window['localStorage'] isnt null

  require('inherit')
    __constructor: (typeName, Type, typeFactory, typeSerializer) ->
      assert typeof typeName is 'string', 'Type name should be a string'
      assert typeName.indexOf(@__self.TYPE_ID_SEPARATOR) is -1, "Type name should not contain #{@__self.TYPE_ID_SEPARATOR}"

      assert typeof Type is 'function', 'Type should be a constructor'
      assert typeof typeFactory is 'function', 'TypeFactory should be a factory method to generate Type instance'
      assert typeof typeSerializer is 'function', 'TypeSerializer should be a method to serialize Type to a string'

      ###*
      # Type constructor to check stored items against
      # All stored items should be of this type
      ###
      @_Type = Type

      ###*
      # Type name to store the items under
      # Used as a key to localStorage
      ###
      @_typeName = typeName

      ###*
      # Factory method to produce Type instances
      # given a previously serialized Type instance
      ###
      @_typeFactory = typeFactory

      ###*
      # Serializer method to convert a Type instance
      # into a persistent string
      ###
      @_typeSerializer = typeSerializer

      return @

    getKey: (id) ->
      id = id || ''
      @_typeName + @__self.TYPE_ID_SEPARATOR + id

    put: (id, item) ->
      assert id and typeof id is 'string', 'Id should be a string'
      assert item instanceof @_Type, "#{@_typeName} instance expected"

      @_putID(id)

      @__self.persist(@getKey(id), @_typeSerializer(item))

    fetch: (id) ->
      assert id and typeof id is 'string', 'Id should be a string'
      @_typeFactory @__self.retrieve(@getKey(id))

    _putID: (id) -> #TODO: test
      ids = @_getIDs()
      ids.push(id)

      @__self.persist(
        @getKey(),
        JSON.stringify(require('_').uniq(ids))
      )

    _getIDs: () -> #TODO: test
      ids = @__self.retrieve(@getKey())
      return JSON.parse(ids) if ids
      return []

    fetchAll: -> #TODO: test
      @_getIDs().map (id) => @fetch(id)

  ,
    persist: (key, value) ->
      assert key and typeof key is 'string', 'Key should be a string'
      assert typeof value is 'string', 'Value should be a string'

      try
        LS.setItem(key, value)
      catch error
        return null

    retrieve: (key) ->
      assert key and typeof key is 'string', 'Key should be a string'

      try
        LS.getItem(key)
      catch error
        return null

    TYPE_ID_SEPARATOR: '###'
