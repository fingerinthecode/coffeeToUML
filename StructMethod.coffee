StructElement = require "./StructElement"

class StructMethod extends StructElement
  #@field _arguments Array
  #@field _argumentsTypes Array
  #@field _returnType String

  #@sign (String, Array)
  constructor: (@_name, @_arguments) ->
    super(@_name)
    @_argumentsTypes = []

  #@sign (Array)
  setArgumentsTypes: (argTypes) ->
    @_argumentsTypes = argTypes

  #@sign (String)
  setReturnType: (type) ->
    @_returnType = type

  #@sign () String
  getReturnType: () ->
    @_returnType

  #@sign () Dictionary
  getArgumentsAndTypes: () ->
    result = {}
    for i, arg of @_arguments
      result[arg] = @_argumentsTypes[i]
    return result

module.exports = StructMethod