require ['inherit', 'AbstractMessageBody.coffee'], (inherit, AbstractMessageBody) ->
  supportedContentType = 'text/plain'
  inherit AbstractMessageBody, {},
    getContentType: -> supportedContentType
    decodes: (contentType) -> contentType is supportedContentType


