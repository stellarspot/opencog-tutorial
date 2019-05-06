from opencog.ure import ForwardChainer
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.atomspace import TruthValue

# Initialize AtomSpace

atomspace = AtomSpace()
initialize_opencog(atomspace)

# Import URE Deduction Rules
from example_deduction import *

# Knowledge Base
A = ConceptNode("A")
B = ConceptNode("B")
C = ConceptNode("C")

AB = InheritanceLink(A, B)
BC = InheritanceLink(B, C)

A.tv = TruthValue(1, 1)
AB.tv = TruthValue(0.8, 0.9)
BC.tv = TruthValue(0.85, 0.95)

# Run Forward Chainer

sources = SetLink(AB)
chainer = ForwardChainer(atomspace, deduction_rbs, sources)

chainer.do_chain()
results = chainer.get_results()
print(results)
