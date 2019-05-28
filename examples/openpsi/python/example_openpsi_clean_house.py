import time
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.openpsi import *

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)
scheme_eval(atomspace, "(use-modules (opencog) (opencog exec) (opencog openpsi))")

openpsi = OpenPsi(atomspace)

# Clean Home

component = openpsi.create_component("clean-home")


# Sweep Floor

def sweep_floor(garbage_node):
    print("sweep floor:", garbage_node.name)
    return InheritanceLink(garbage_node, ConceptNode("done"))

goal_sweep_floor = openpsi.create_goal("goal-sweep-floor")

context_sweep_floor = [
    InheritanceLink(
        VariableNode("$GARBAGE"),
        ConceptNode("garbage")),
    AbsentLink(
        InheritanceLink(
            VariableNode("$GARBAGE"),
            ConceptNode("done")))
]

action_sweep_floor = ExecutionOutputLink(
    GroundedSchemaNode("py: sweep_floor"),
    ListLink(
        VariableNode("$GARBAGE")))

rule_sweep_floor = openpsi.add_rule(context_sweep_floor,
                                    action_sweep_floor,
                                    goal_sweep_floor,
                                    TruthValue(1.0, 1.0),
                                    component)


# Wash Dish

def wash_dish(dish_node):
    print("wash dish:", dish_node.name)
    return InheritanceLink(dish_node, ConceptNode("done"))


goal_wash_dish = openpsi.create_goal("goal-wash-dish")

context_wash_dish = [
    InheritanceLink(
        VariableNode("$DISH"),
        ConceptNode("dish")),
    AbsentLink(
        InheritanceLink(
            VariableNode("$DISH"),
            ConceptNode("done")))
]

action_wash_dish = ExecutionOutputLink(
    GroundedSchemaNode("py: wash_dish"),
    ListLink(
        VariableNode("$DISH")))

rule_wash_dish = openpsi.add_rule(context_wash_dish,
                                  action_wash_dish,
                                  goal_wash_dish,
                                  TruthValue(1.0, 1.0),
                                  component)

# Run OpenPsi

count = 0


def clean_house_action_selector(comp):
    global count
    count = (count + 1) % 2

    rules = {0: rule_sweep_floor, 1: rule_wash_dish}
    rule = rules[count]
    tv = rule.is_satisfiable()
    if tv.mean >= 0.5:
        return SetLink(rule.get_rule_atom())
    else:
        return SetLink()


openpsi.set_action_selector(component, "clean_house_action_selector")

openpsi.run(component)

delay = 0.2

InheritanceLink(ConceptNode("garbage-1"), ConceptNode("garbage"))
InheritanceLink(ConceptNode("garbage-2"), ConceptNode("garbage"))
InheritanceLink(ConceptNode("garbage-3"), ConceptNode("garbage"))

InheritanceLink(ConceptNode("dish-1"), ConceptNode("dish"))
InheritanceLink(ConceptNode("dish-2"), ConceptNode("dish"))
InheritanceLink(ConceptNode("dish-3"), ConceptNode("dish"))

time.sleep(delay)

openpsi.halt(component)
