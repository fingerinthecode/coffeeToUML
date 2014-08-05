StructClass = require "./StructClass"
StructMethod = require "./StructMethod"
StructField = require "./StructField"


indentRegExp       = new RegExp /(\s*).+/
classRegExp        = new RegExp /class ([a-zA-Z][a-zA-Z0-9]*)( extends ([a-zA-Z][a-zA-Z0-9]*))?/
methodRegExp       = new RegExp /(@?\w+)\s*:\s*(\(([@\w,= '\[\]\{\}:"]*)\))?\s*(-|=)>/
signatureRegExp    = new RegExp /sign\s*\(([@\w,\s]*)\)\s*(\w*)/
fieldRegExp        = new RegExp /(@?\w+)\s*:/
commentFieldRegExp = new RegExp /#@field (.+) (.+)/

class Parser
  #@sign (String, Integer) Integer
  @indentLength: (line, currentIndent) ->
    match = indentRegExp.exec(line)
    if match
      return match[1].length
    return currentIndent

  #@sign (String) StructClass
  @parseAsClass: (line) ->
    match = classRegExp.exec(line)
    if match
      klass = new StructClass(match[1])
      if match.length > 3 and match[3]?
        klass.addRelation('extends', match[3])
      return klass


  #@sign (String) StructMethod
  @parseAsMethod: (line) ->
    match = methodRegExp.exec(line)
    if match
      args = []
      if match.length >= 5 and match[3]
        args = match[3].split(",").map (e) ->
          e.replace( /^\s+/, '')
          .replace(/(.*)\s*=\s*(.*)/, "$1")
      return new StructMethod(match[1], args)

  #@sign (String) StructField
  @parseAsField: (line) ->
    match = fieldRegExp.exec(line)
    if match
      return new StructField(match[1])

  #@sign (String, StructMethod)
  @parseAsSignature: (line, method) ->
    console.log line
    match = signatureRegExp.exec(line)
    if match
      args = @_parseArgTypes(match[1])
      method.setArgumentsTypes args
      if match[2]
        method.setReturnType match[2]

  #@sign (String) Array
  @_parseArgTypes: (args) ->
    args = args.split(',').map (e) ->
      return e.replace /^\s+/, ''
    return args

  #@sign (String) StructField
  @parseAsCommentField: (line) ->
    match = commentFieldRegExp.exec(line)
    if match and match.length >= 3
      field = new StructField(match[1])
      field.setType(match[2])
      return field

  #@sign (String) Dictionary
  @parse: (string, structure) ->
    lines = string.split '\n'
    pointer = 0
    previousIndent = 0
    insideClass = false

    unusefulCommentRegExp = new RegExp /^\s*#[^@]/
    commentRegExp = new RegExp(/#@(.+)/)
    commentGroupFinished = true

    while pointer < lines.length
      line = lines[pointer]

      currentIndent = @indentLength(line, currentIndent)
      if currentIndent < previousIndent
        if classIndent? and currentIndent <= classIndent
          #currentClass = undefined
          insideClass = false
          #console.log "leave"

      if not unusefulCommentRegExp.test(line)
        match = commentRegExp.exec(line)
        if match
          if commentGroupFinished
            commentGroupFinished = false
            commentGroup = []
            commentGroupIndent = currentIndent
          if currentClass? and currentIndent == classContentIndent
            field = @parseAsCommentField(line)
            if field
              currentClass.addField(field)
          if currentIndent == commentGroupIndent
            commentGroup.push match[1]
          else
            if match[1].length < commentGroupIndent
              commentGroupIndent = currentIndent
              commentGroup = []
        else
          commentGroupFinished = true

          if not insideClass
            currentClass = @parseAsClass(line)
            if currentClass?
              insideClass = true
              classIndent = currentIndent
              #console.log currentClass.getName(), currentClass
              structure[currentClass.getName()] = currentClass
              if commentGroupIndent? and commentGroupIndent == currentIndent
                #relations
                console.log "relation", line
          else
            if not classContentIndent?
              classContentIndent = currentIndent
            if currentIndent == classContentIndent
              method = @parseAsMethod(line)
              if method
                if commentGroupIndent == currentIndent
                  #console.log commentGroup
                  for comment in commentGroup
                    @parseAsSignature comment, method
                #console.log method._name
                currentClass.addMethod(method)
              else
                field = @parseAsField(line)
                if field
                  #console.log field
                  currentClass.addField(field)

      previousIndent = currentIndent
      pointer++
    return structure

module.exports = Parser