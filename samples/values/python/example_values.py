from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

string_key = ConceptNode("string-key")
string_node = ConceptNode("String")
string_node.set_value(string_key, StringValue("Hello, World!"))

string_value = string_node.get_value(string_key)
print(string_value.to_list())

string_node.set_value(string_key, StringValue(["Hello", "Opencog!"]))
string_value = string_node.get_value(string_key)
print(string_value.to_list())

string_value = string_node.get_value(string_key)
print(string_value.to_list())

from opencog.atomspace import PtrValue
import numpy as np

# Matrix
# (0, 1)
# (1, 0)
matrix = np.matrix([[0, 1], [1, 0]])

matrix_key = ConceptNode("matrix-key")
matrix_node = ConceptNode("Matrix")
matrix_node.set_value(matrix_key, PtrValue(matrix))

matrix_value = matrix_node.get_value(matrix_key)

print(matrix_value.value())
