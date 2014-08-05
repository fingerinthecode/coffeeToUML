fs       = require 'fs'
path     = require 'path'
Parser   = require './Parser'
Exporter = require "./Exporter"

if process.argv.length < 3
  console.error "Bad arguments"
else
  console.log process.argv[2]

pathString = process.argv[2]

structure = {}

recursivelyParse = (pathString, structure) ->
  if fs.lstatSync(pathString).isDirectory()
    for filename in fs.readdirSync pathString
      recursivelyParse(path.join(pathString, filename), structure)
  else
    fileContent = fs.readFileSync pathString, {encoding: 'utf8'}
    console.log "read file", pathString
    Parser.parse(fileContent, structure)
    console.log "\n\n\n"

recursivelyParse(pathString, structure)

Exporter.toString(structure)

Exporter.toPNG(structure)
