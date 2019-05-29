from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

ConceptNode("node-1")
ConceptNode("node-2")
print("nodes in atomspace:", atomspace.size())

DeleteLink(ConceptNode("node-1"))
print("nodes in atomspace:", atomspace.size())

DeleteLink(ConceptNode("node-2"))
print("nodes in atomspace:", atomspace.size())
