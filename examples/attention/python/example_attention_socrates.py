from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom
from opencog.atbank import AttentionBank, af_bindlink

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

attention_bank = AttentionBank(atomspace)

socrates = ConceptNode("Socrates")
einstein = ConceptNode("Einstein")
peirce = ConceptNode("Peirce")
man = ConceptNode("man")

attention_bank.set_sti(socrates, 1)
attention_bank.set_lti(socrates, 2)

link1 = InheritanceLink(socrates, man)
link2 = InheritanceLink(einstein, man)
link3 = InheritanceLink(peirce, man)

attention_bank.set_av(link2, 35, 10)

bind_link = BindLink(
    VariableNode("$X"),
    InheritanceLink(VariableNode("$X"), man),
    VariableNode("$X")
)

res = af_bindlink(atomspace, bind_link)
print("attention focus bind:\n", res)

res = execute_atom(atomspace, bind_link)
print("ordinary bind:\n", res)
