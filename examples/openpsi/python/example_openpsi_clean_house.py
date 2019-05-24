import time
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.scheme_wrapper import scheme_eval
from opencog.openpsi import *

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)
scheme_eval(atomspace, "(use-modules (opencog) (opencog exec) (opencog openpsi))")

openpsi = OpenPsi(atomspace)

# Clean Home
component = ConceptNode("clean-home")


# Sweep Floor

# Called by OpenPsi Action
def sweep_floor(garbage_node):
    print("sweep_floor:", garbage_node.name)
    return InheritanceLink(garbage_node, ConceptNode("done"))


goal = ConceptNode("goal-sweep-floor")

context = [
    InheritanceLink(
        VariableNode("$GARBAGE"),
        ConceptNode("garbage")),
    AbsentLink(
        InheritanceLink(
            VariableNode("$GARBAGE"),
            ConceptNode("done")))
]

action = ExecutionOutputLink(
    GroundedSchemaNode("py: sweep_floor"),
    ListLink(
        VariableNode("$GARBAGE")))

openpsi.init_component(component)

rule = openpsi.add_rule(context, action, goal, TruthValue(1.0, 1.0), component)

openpsi.run(component)

# Apples are handled by OpenPsi loop
InheritanceLink(ConceptNode("garbage-1"), ConceptNode("garbage"))
InheritanceLink(ConceptNode("garbage-2"), ConceptNode("garbage"))

delay = 0.02
time.sleep(delay)

openpsi.halt(component)
