class StructElement
  #@field _name String
  #@field _isStatic Boolean
  #@field _isPrivate Boolean

  #@sign (String)
  constructor: (@_name) ->
    @_isStatic = @_name[0] == "@"
    @_isPrivate = @_name[if @_isStatic then 1 else 0] == "_"

  #@sign () String
  getName: () ->
    @_name

  #@sign () Boolean
  isPrivate: () ->
    @_isPrivate

  #@sign () Boolean
  isStatic: () ->
    @_isStatic

module.exports = StructElement