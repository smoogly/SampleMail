define ['_', 'inherit', './AbstractMessageBody'], (_, inherit, AbstractMessageBody) ->
  supportedContentType = 'text/plain'
  inherit AbstractMessageBody,
    toHTML: -> _.escape(@_content).replace(/\n/g, "<br />")
    getFirstLine: -> @_content.substr(0, 100);
  ,
    getContentType: -> supportedContentType
    decodes: (contentType) -> contentType is supportedContentType


