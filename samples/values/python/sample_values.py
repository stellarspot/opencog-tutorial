from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.atomspace import PtrValue

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

from opencog.atomspace import PtrValue
import numpy as np

# Matrix
# (0, 1)
# (1, 0)
matrix = np.array([0, 1, 1, 0]).reshape([2, 2])

matrix_key = ConceptNode("matrix-ket")
matrix_node = ConceptNode("Matrix")
matrix_node.set_value(matrix_key, PtrValue(matrix))

matrix_value = matrix_node.get_value(matrix_key)

print(matrix_value.value())
