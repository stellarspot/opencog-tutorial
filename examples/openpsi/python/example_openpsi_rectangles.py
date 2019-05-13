import time
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

PARENT_RECT = ConceptNode("rectangle")
KEY_CORNES = ConceptNode("key-corners")


# ; Rectangles are stored in Atomspace as
# ;
# ; (Inheritance (Concept "my-rect") PARENT_RECT)
# ;
# ; (Evaluation
# ;   (Predicate "id")
# ;     (List
# ;      (Number 123)
# ;      (Concept "my-rect")))
# ;
# ; x1, y1, x2, y2 are stored as values with the key key-cornes

def add_rect(id, name, x1, y1, x2, y2):
    rect = ConceptNode(name)
    rect.set_value(KEY_CORNES, FloatValue([x1, y1, x2, y2]))
    return SetLink(
        InheritanceLink(rect, PARENT_RECT),
        (EvaluationLink(
            PredicateNode("id"),
            ListLink(
                NumberNode(id),
                rect))))


# Called by OpenPsi Action
def find_the_same_rects(params):
    rect1 = params.get_out()[0]
    rect2 = params.get_out()[1]
    print("[openpsi] find the same rects:", rect1.name, rect2.name)
    # Mark rectangles as handled
    return SetLink(
        EvaluationLink(PredicateNode("handle-rect"), rect1),
        EvaluationLink(PredicateNode("handle-rect"), rect2))


# OpenPsi components

def check_the_same_rects(rect1, rect2):
    print("[openpsi] check the same rects")
    if rect1.get_value(KEY_CORNES) == rect2.get_value(KEY_CORNES):
        return TruthValue(1.0, 1.0)
    else:
        return TruthValue(0.0, 1.0)


# OpenPsi context
def context_find_the_same_rects():
    return AndLink(
        EvaluationLink(
            PredicateNode("id"),
            ListLink(
                VariableNode("$ID_1"),
                (VariableNode("$RECT_1")))
        ),
        InheritanceLink(
            VariableNode("$RECT_1"),
            PARENT_RECT
        ),
        AbsentLink(
            EvaluationLink(
                PredicateNode("handle-rect"),
                VariableNode("$RECT_1"))
        ),
        EvaluationLink(
            PredicateNode("id"),
            ListLink(
                VariableNode("$ID_2"),
                (VariableNode("$RECT_2")))),
        InheritanceLink(
            VariableNode("$RECT_2"),
            PARENT_RECT
        ),
        AbsentLink(
            EvaluationLink(
                PredicateNode("handle-rect"),
                VariableNode("$RECT_2"))
        ),
        NotLink(
            EqualLink(
                VariableNode("$RECT_1"),
                VariableNode("$RECT_2"))),
        # EvaluationLink(
        #     GroundedSchemaNode("py: check_the_same_rects"),
        #     ListLink(
        #         VariableNode("$RECT_1"),
        #         VariableNode("$RECT_2"))
        # )
    )


# Pass OpenPsi context to Scheme
EvaluationLink(
    PredicateNode("openpsi-context"),
    context_find_the_same_rects())

# Call Scheme
from opencog.scheme_wrapper import scheme_eval

scheme_eval(atomspace,
            '''
            (use-modules
              (opencog)
              (opencog exec)
              (opencog openpsi)
              (opencog python))

            ; OpenPsi Goal
            (define goal-find-the-same-rects
             (Concept "goal-find-the-same-rects"))


            ; OpenPsi Action
            (define action-find-the-same-rects
             (ExecutionOutput
              (GroundedSchema "py: find_the_same_rects")
              (List
               (List
                (Variable "$RECT_1")
                (Variable "$RECT_2")))))

            ; OpenPsi Component
            (define component-find-the-same-rects
             (psi-component "component-find-the-same-rects"))

            ; OpenPsi Context retrieved from Python
            (define context-find-the-same-rects
             (cog-outgoing-set
              (car
               (cog-outgoing-set
                (cog-execute!
                 (Get
                  (Evaluation
                   (Predicate "openpsi-context")
                   (Variable "$CONTEXT"))))))))

            ; OpenPsi rule
                (define rule-1
                 (psi-rule
                  context-find-the-same-rects
                  action-find-the-same-rects
                  goal-find-the-same-rects
                  (stv 1 1)
                  component-find-the-same-rects))

            ; Run OpenPsi
            (psi-run component-find-the-same-rects)

            ''')

delay = 0.05

add_rect("1", "rect1", 100, 100, 200, 200)
add_rect("2", "rect2", 100, 100, 400, 400)
add_rect("3", "rect3", 100, 100, 200, 200)

time.sleep(delay)
add_rect("4", "rect4", 200, 200, 400, 400)

time.sleep(delay)
add_rect("5", "rect5", 100, 100, 400, 400)

scheme_eval(atomspace,
            '''
            (use-modules
              (opencog)
              (opencog openpsi))

            ; Stop OpenPsi
            (psi-halt component-find-the-same-rects)
           ''')

print("The End!")
# time.sleep(2)
