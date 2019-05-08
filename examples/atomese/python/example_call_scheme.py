from opencog.type_constructors import *
from opencog.utilities import initialize_opencog

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)

# Call Scheme
from opencog.scheme_wrapper import scheme_eval

scheme_eval(atomspace,
            '''
            (use-modules (opencog))
            (cog-set-value! (Concept "sample") (Concept "key") (StringValue "sample-value"))
            ''')

# Check Scheme results
value = ConceptNode("sample").get_value(ConceptNode("key"))
print("value:", value)
