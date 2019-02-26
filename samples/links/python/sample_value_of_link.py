from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

key = PredicateNode("key")
atom = ConceptNode("atom")
atom.set_value(key, FloatValue(3))

value_of_link = ValueOfLink(atom, key)

res = execute_atom(atomspace, value_of_link)
print(res)
