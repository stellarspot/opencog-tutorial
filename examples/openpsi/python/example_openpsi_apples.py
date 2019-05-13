import time
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

APPLE = ConceptNode("apple")


# Called by OpenPsi Action
def eat_apple(apple):
    print("[openpsi] eat apple:", apple.name)
    # Mark apple as handled
    InheritanceLink(apple, ConceptNode("handled"))
    return ConceptNode("finished")


# OpenPsi context
def openpsi_context():
    return AndLink(
        InheritanceLink(
            VariableNode("$APPLE"),
            APPLE),
        AbsentLink(
            InheritanceLink(
                VariableNode("$APPLE"),
                ConceptNode("handled"))))


# Pass OpenPsi context to Scheme
EvaluationLink(
    PredicateNode("openpsi-context"),
    openpsi_context())

# Call Scheme
from opencog.scheme_wrapper import scheme_eval

scheme_eval(atomspace,
            '''
            (use-modules
             (opencog)
             (opencog exec)
             (opencog openpsi))

            ; OpenPsi sample
            ; Eat apples

            ; OpenPsi Goal: eat apples
            (define goal
             (Concept "goal-eat-apples"))

            ; OpenPsi Context retrieved from Python
            (define context
             (cog-outgoing-set
              (car
               (cog-outgoing-set
                (cog-execute!
                 (Get
                  (Evaluation
                   (Predicate "openpsi-context")
                   (Variable "$CONTEXT"))))))))


            ; OpenPsi Action: eat apple
            ; Call Python method implementation
            (define action
             (ExecutionOutput
              (GroundedSchema "py: eat_apple")
              (List
               (Variable "$APPLE"))))

            ; OpenPsi component
            (define component (psi-component "component"))

            ; OpenPsi Rule: Eat apple
            (define rule
             (psi-rule
              context
              action
              goal
              (stv 1 1)
              component))


            ; Run OpenPsi
            (psi-run component)
            ''')

delay = 0.2

InheritanceLink(ConceptNode("apple-1"), APPLE)
InheritanceLink(ConceptNode("apple-2"), APPLE)

time.sleep(delay)

InheritanceLink(ConceptNode("apple-3"), APPLE)
InheritanceLink(ConceptNode("apple-4"), APPLE)

time.sleep(delay)

scheme_eval(atomspace,
            '''
            ; Stop OpenPsi
            (psi-halt component)
            ''')
