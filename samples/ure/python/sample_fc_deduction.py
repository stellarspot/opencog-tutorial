from opencog.ure import ForwardChainer
from opencog.scheme_wrapper import scheme_eval
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.atomspace import TruthValue

# Initialize AtomSpace

atomspace = AtomSpace()
initialize_opencog(atomspace)

# Knowledge Base
A = ConceptNode("A")
B = ConceptNode("B")
C = ConceptNode("C")

AB = InheritanceLink(A, B)
BC = InheritanceLink(B, C)

A.tv = TruthValue(1, 1)
AB.tv = TruthValue(0.8, 0.9)
BC.tv = TruthValue(0.85, 0.95)

# =============================================================================
# Crisp logic entailment (Deduction) Rule.
#
#  A->B
#  B->C
#  |-
#  A->C
#
# See https://github.com/opencog/atomspace/tree/master/examples/rule-engine for more details.
# -----------------------------------------------------------------------------

fc_deduction_rule = BindLink(
    VariableList(
        TypedVariableLink(
            VariableNode('$A'),
            TypeNode('ConceptNode')),
        TypedVariableLink(
            VariableNode('$B'),
            TypeNode('ConceptNode')),
        TypedVariableLink(
            VariableNode('$C'),
            TypeNode('ConceptNode'))),
    AndLink(
        InheritanceLink(
            VariableNode('$A'),
            VariableNode('$B')),
        InheritanceLink(
            VariableNode('$B'),
            VariableNode('$C')),
        NotLink(
            EqualLink(
                VariableNode('$A'),
                VariableNode('$C')))),
    ExecutionOutputLink(
        GroundedSchemaNode('py: fc_deduction_formula'),
        ListLink(
            InheritanceLink(
                VariableNode('$A'),
                VariableNode('$C')),
            InheritanceLink(
                VariableNode('$A'),
                VariableNode('$B')),
            InheritanceLink(
                VariableNode('$B'),
                VariableNode('$C')))))


# -----------------------------------------------------------------------------
# Deduction Formula
#
# If both confidence and strength of A->B and B->C are above 0.5 then
# set the TV of A->C to (stv 1 1)
# -----------------------------------------------------------------------------

def fc_deduction_formula(AC, AB, BC):
    tv1 = AB.tv
    tv2 = BC.tv

    if tv1.mean > 0.5 and tv2.mean > 0.5 and tv1.confidence > 0.5 and tv2.confidence > 0.5:
        AC.tv = TruthValue(1, 1)
    else:
        AC.tv = TruthValue(0, 0)

    return AC

# Load rules

fc_deduction_rule_name = DefinedSchemaNode("fc-deduction-rule")

DefineLink(
    fc_deduction_rule_name,
    fc_deduction_rule)

fc_deduction_rbs = ConceptNode("fc-deduction-rule-base")

InheritanceLink(
    fc_deduction_rbs,
    ConceptNode("URE")
)

execute_code = \
    '''
    (use-modules (opencog) (opencog query) (opencog exec) (opencog rule-engine))

    (define fc-deduction-rbs (ConceptNode "fc-deduction-rule-base"))

    (define fc-deduction-rule-name
        (DefinedSchemaNode "fc-deduction-rule"))

    (ure-add-rules fc-deduction-rbs (list fc-deduction-rule-name))

    (ure-set-num-parameter fc-deduction-rbs "URE:maximum-iterations" 30)

    (ure-set-fuzzy-bool-parameter fc-deduction-rbs "URE:attention-allocation" 0)
    '''

scheme_eval(atomspace, execute_code)

# Forward Chainer

chainer = ForwardChainer(atomspace,
                         ConceptNode("fc-deduction-rule-base"),
                         InheritanceLink(VariableNode("$who"), C),
                         TypedVariableLink(VariableNode("$who"), TypeNode("ConceptNode")))

chainer.do_chain()
results = chainer.get_results()

print(results)
