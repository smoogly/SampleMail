require ['inherit', 'assert', '../../../Error/NotImplementedError.coffee'], (inherit, assert, NotImplementedError) ->
  inherit
    __constructor: (content) ->
      assert typeof content is 'string'
      @_content = content
  ,
    ###*
    # Gets the content type to write into the email
    # Message body should return a content type parseable by that same message body:
    # mBody.decodes mBody.getContentType() # True
    #
    # @returns String
    ###
    getContentType: -> throw new NotImplementedError()


    ###*
    # Whether this MessageBody supports the given content type
    #
    # @returns Boolean
    ###
    decodes: (contentType) -> throw new NotImplementedError()
