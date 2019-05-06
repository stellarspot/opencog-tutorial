from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)


def pow(node_a, node_b):
    a = int(float(node_a.name))
    b = int(float(node_b.name))
    return NumberNode(str(a ** b))


execution_output_link = ExecutionOutputLink(
    GroundedSchemaNode("py: pow"),
    ListLink(
        NumberNode("2"),
        NumberNode("5")
    ))

res = execute_atom(atomspace, execution_output_link)
print(res)
