define ['_', 'inherit', './AbstractMessageBody'], (_, inherit, AbstractMessageBody) ->
  supportedContentType = 'text/plain'
  inherit AbstractMessageBody,
    toHTML: ->
      _.escape(@_content).replace(/\n/g, "<br />")
  ,
    getContentType: -> supportedContentType
    decodes: (contentType) -> contentType is supportedContentType


