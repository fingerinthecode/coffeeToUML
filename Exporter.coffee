fs   = require "fs"
exec = require('child_process').exec

class Exporter
  #@field @_javaTypeMapping Dictionary
  @_javaTypeMapping:
    Integer: "int"

  #@sign (Dictionary) String
  @toString: (structure) ->
    for k,v of structure
      console.log k, v.getName()
      console.log v.getRelations()
      console.log "  fields"
      for k2, v2 of v._fields
        console.log "    ", k2, ":", v2._type
      console.log "  methods"
      for meth in v._methods
        console.log "    ", meth._name, "(", meth.getArgumentsAndTypes(), ") :", meth._returnType

  #@sign (Array) String
  @_toJavaCommentBloc: (list) ->
    res = "/**\n"
    for e in list
      res += " * " + e + "\n"
    res += " */\n"

  #@sign (String) String
  @_toJavaType: (type) ->
    if @_javaTypeMapping[type]? then @_javaTypeMapping[type] else type

  #@sign (String) String
  @_javaClean: (element) ->
    if element[0] == "@" then element.substr(1) else element

  #@sign (Dictionary) String
  @toUmlGraph: (structure) ->
    result = @_toJavaCommentBloc ["UML"]

    # options
    result += @_toJavaCommentBloc [
      "@opt operations"
      "@opt attributes"
      "@opt types"
      "@opt visibility"
      "@hidden"
    ]
    result += "class UMLOptions {}\n\n"

    result += @_toJavaCommentBloc ["@hidden"]
    result += "class Dictionary {}\n\n"
    result += @_toJavaCommentBloc ["@hidden"]
    result += "class Array {}\n\n"

    for name, klass of structure
      extendsRel = []
      for rType, relClass of klass.getRelations()
        if rType == "extends"
          extendsRel.push relClass
      result += "class " + name
      if extendsRel.length > 0
        result += " extends " + extendsRel[0]
      result += " {\n"
      for fName, field of klass.getFields()
        line = "\t"
        line += if field.isPrivate() then "private" else "public"
        line += " " + if field.isStatic() then "static " else ""
        type = field.getType()
        line += if type? then @_toJavaType(type) else "Object"
        line += " " + @_javaClean(fName)
        line += ";\n"
        result += line

      for method in klass.getMethods()
        line = "\t"
        line += if method.isPrivate() then "private" else "public"
        line += " " + if method.isStatic() then "static " else ""
        type = method.getReturnType()
        line += if type? then @_toJavaType(type) else "void"
        line += " " + @_javaClean(method.getName()) + "("
        first = true
        for arg, type of method.getArgumentsAndTypes()
          if not first
            line += ", "
          line += (@_toJavaType(type) or "Object") + " " + @_javaClean(arg)
          first = false
        line += ")"
        line += ";\n"
        result += line
      result += "}\n\n"
    result

  #@sign (Dictionary)
  @toPNG: (structure) ->
    fs.writeFileSync("/tmp/ToUml.java", @toUmlGraph(structure))
    #exec('')

module.exports = Exporter