coffeeToUML
===========

Sorte of reverse engineering to build UML class diagram from coffeescript source code (with dedicated comments)

Uses (and needs) http://www.umlgraph.org

For now coffeeToUML generates Java-like code which is transformed to UML with a command like:
`java -jar <pathToJar>/UmlGraph.jar -private -output - <pathToJavaFile>/ToUml.java | dot -Tpng -ograph.png`

Javadoc and dot are needed (Ubuntu: sudo aptitude install openjdk-7-doc, graphviz)
