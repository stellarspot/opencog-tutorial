from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.atomspace import create_child_atomspace
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

ConceptNode("cat")
ConceptNode("dog")

for atom in atomspace:
    print('parent atom:', atom)

child_atomspace = create_child_atomspace(atomspace)

for atom in child_atomspace:
    print('child atom:', atom)
