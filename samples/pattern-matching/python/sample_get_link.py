from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

red = ConceptNode("red")
green = ConceptNode("green")

InheritanceLink(ConceptNode("ball1"), red)
InheritanceLink(ConceptNode("ball2"), green)
InheritanceLink(ConceptNode("ball3"), red)
InheritanceLink(ConceptNode("ball4"), green)

red_balls_rule = GetLink(
    InheritanceLink(
        VariableNode("$BALL"),
        red))

res = execute_atom(atomspace, red_balls_rule)
print(res)
