define ->
  {
    uuid: -> #Courtesy of Stackoverflow
      'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (char) ->
        random = Math.random()*16|0
        value = if char is 'x' then random else random&0x3|0x8
        value.toString(16)
  }
