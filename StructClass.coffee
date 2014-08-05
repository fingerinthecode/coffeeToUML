StructElement = require "./StructElement"

class StructClass extends StructElement
  #@field _name String
  #@field _fields Dictionary
  #@field _methods Array
  #@field _relations Dictionary

  #@sign (String)
  constructor: (@_name) ->
    super(@_name)
    @_fields = {}
    @_methods = []
    @_relations = {}

  #@sign (String, String)
  addRelation: (type, className) ->
    @_relations[type] = className

  #@sign (StructMethod)
  addMethod: (method) ->
    @_methods.push method

  #@sign (StructField)
  addField: (field) ->
    if not @_fields[field.getName()] or not @_fields[field.getName()].getType()
      @_fields[field.getName()] = field

  #@sign () Dictionary
  getFields: () ->
    @_fields

  #@sign () Array
  getMethods: () ->
    @_methods

  #@sign () Array
  getRelations: () ->
    @_relations

module.exports = StructClass