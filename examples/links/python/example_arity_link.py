from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

arity_link = ArityLink(
    ListLink(
        ConceptNode("apple"),
        ConceptNode("orange"),
        ConceptNode("pear")))

res = execute_atom(atomspace, arity_link)
print(res)
