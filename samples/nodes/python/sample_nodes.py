from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace

atomspace = AtomSpace()
initialize_opencog(atomspace)

ConceptNode("cat")
ConceptNode("green")
ConceptNode("ball")
