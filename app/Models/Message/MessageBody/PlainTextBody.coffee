define ['_', 'inherit', './AbstractMessageBody'], (_, inherit, AbstractMessageBody) ->
  supportedContentType = 'text/plain'
  inherit AbstractMessageBody,
    toHTML: -> _.escape(@_content).replace(/\n/g, "<br />")

    getFirstLine: ->
      firstline = @_content.trim()

      # Firstline should be short
      firstline = @_content.substr(0, 100).trim() + '…' if @_content.length > 101

      # Should not contain any quotes
      firstline.split('>', 2)[0]
  ,
    getContentType: -> supportedContentType
    decodes: (contentType) -> contentType is supportedContentType


