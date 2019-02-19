from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

(DefineLink(
    DefinedSchemaNode('add'),
    LambdaLink(
        VariableList(
            TypedVariableLink(
                VariableNode('$A'),
                TypeNode('NumberNode')),
            TypedVariableLink(
                VariableNode('$B'),
                TypeNode('NumberNode'))),
        PlusLink(
            VariableNode('$A'),
            VariableNode('$B')))))

res = execute_atom(atomspace,
                   ExecutionOutputLink(
                       DefinedSchemaNode('add'),
                       ListLink(
                           NumberNode("3"),
                           NumberNode("4"))))
print(res)
