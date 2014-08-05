StructElement = require "./StructElement"

class StructField extends StructElement
  #@field _type String

  #@sign () String
  getType: () ->
    @_type

  #@sign (String)
  setType: (type) ->
    @_type = type

module.exports = StructField