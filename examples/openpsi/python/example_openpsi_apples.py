import time
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

APPLE = ConceptNode("apple")


# Called by OpenPsi Action
def eat_apple(apple):
    print("[openpsi] eat apple")
    print(apple)
    ConceptNode("finished")


# # OpenPsi context
# def openpsi_context():
#     return AndLink(
#         InheritanceLink(
#             VariableNode("$APPLE"),
#             APPLE))
#
#
# # Pass OpenPsi context to Scheme
# EvaluationLink(
#     PredicateNode("openpsi-context"),
#     openpsi_context())
#

# Call Scheme
from opencog.scheme_wrapper import scheme_eval

scheme_eval(atomspace,
            '''
(use-modules
 (opencog)
 (opencog openpsi))

; OpenPsi sample
; Eat apples

; OpenPsi Goal: eat apples
(define goal
 (Concept "goal-eat-apples"))

(define context
 (list
  (Inheritance (Variable "$APPLE") (Concept "apple"))))

; OpenPsi Action: eat apple
(define action
 (ExecutionOutput
  (GroundedSchema "scm: eat-apple")
  ;(GroundedSchema "py: eat_apple")
  (List
   (Variable "$APPLE")
  )))

(define (eat-apple apple)
 (display "[openpsi] eat apple action\n")
 (display apple)
 (ConceptNode "finished"))

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

time.sleep(delay)

InheritanceLink(ConceptNode("apple-2"), APPLE)

time.sleep(delay)

scheme_eval(atomspace,
            '''

            ; Stop OpenPsi
            (psi-halt component)
           ''')
