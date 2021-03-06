define ['inherit', 'assert', '../../../Error/NotImplementedError'], (inherit, assert, NotImplementedError) ->
  AbstractMessageBody = inherit
    __constructor: (content) ->
      assert typeof content is 'string'
      @_content = content
      return @

    toHTML: -> throw new NotImplementedError()
    getFirstLine: -> throw new NotImplementedError()
    getRawContent: -> @_content

    ###*
    # Gets the content type to write into the email
    # Message body should return a content type parseable by that same message body:
    # mBody.decodes mBody.getContentType() # True
    #
    # @returns String
    ###
    getContentType: -> throw new NotImplementedError()

  ,

    ###*
    # Whether this MessageBody supports the given content type
    #
    # @returns Boolean
    ###
    decodes: (contentType) -> throw new NotImplementedError()

    serialize: (body) ->
      assert body instanceof AbstractMessageBody, 'Message Body expected'

      JSON.stringify
        content: body.getRawContent()
        type: body.getContentType()


  return AbstractMessageBody
