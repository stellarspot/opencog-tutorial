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

current_goal = "goal-sweep-floor"


def check_goal(goal_node):
    global current_goal
    if current_goal == goal_node.name:
        return TruthValue(1.0, 1.0)
    else:
        return TruthValue(0.1, 0.1)


def set_goal(goal):
    global current_goal
    current_goal = goal


component = ConceptNode("clean-home")


# Sweep Floor

def sweep_floor(garbage_node):
    print("sweep floor:", garbage_node.name)
    global current_goal
    set_goal("goal-wash-dish")
    return InheritanceLink(garbage_node, ConceptNode("done"))


goal_sweep_floor = ConceptNode("goal-sweep-floor")

context_sweep_floor = [
    InheritanceLink(
        VariableNode("$GARBAGE"),
        ConceptNode("garbage")),
    AbsentLink(
        InheritanceLink(
            VariableNode("$GARBAGE"),
            ConceptNode("done"))),
    EvaluationLink(
        GroundedPredicateNode("py: check_goal"),
        ListLink(goal_sweep_floor))
]

action_sweep_floor = ExecutionOutputLink(
    GroundedSchemaNode("py: sweep_floor"),
    ListLink(
        VariableNode("$GARBAGE")))

openpsi.add_rule(context_sweep_floor,
                 action_sweep_floor,
                 goal_sweep_floor,
                 TruthValue(1.0, 1.0),
                 component)


# Wash Dish

def wash_dish(dish_node):
    print("wash dish:", dish_node.name)
    set_goal("goal-sweep-floor")
    return InheritanceLink(dish_node, ConceptNode("done"))


goal_wash_dish = ConceptNode("goal-wash-dish")

context_wash_dish = [
    InheritanceLink(
        VariableNode("$DISH"),
        ConceptNode("dish")),
    AbsentLink(
        InheritanceLink(
            VariableNode("$DISH"),
            ConceptNode("done"))),
    EvaluationLink(
        GroundedPredicateNode("py: check_goal"),
        ListLink(goal_wash_dish))
]

action_wash_dish = ExecutionOutputLink(
    GroundedSchemaNode("py: wash_dish"),
    ListLink(
        VariableNode("$DISH")))

openpsi.add_rule(context_wash_dish,
                 action_wash_dish,
                 goal_wash_dish,
                 TruthValue(1.0, 1.0),
                 component)

# Run OpenPsi
openpsi.init_component(component)
openpsi.run(component)

InheritanceLink(ConceptNode("garbage-1"), ConceptNode("garbage"))
InheritanceLink(ConceptNode("garbage-2"), ConceptNode("garbage"))

InheritanceLink(ConceptNode("dish-1"), ConceptNode("dish"))
InheritanceLink(ConceptNode("dish-2"), ConceptNode("dish"))

delay = 0.2
time.sleep(delay)

openpsi.halt(component)
