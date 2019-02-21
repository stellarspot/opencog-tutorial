from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

put_link = PutLink(
    InheritanceLink(ConceptNode("ball"), VariableNode("$COLOR")),
    ConceptNode("orange")
)

res = execute_atom(atomspace, put_link)
print(res)
