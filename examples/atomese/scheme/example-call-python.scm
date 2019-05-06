(use-modules
 (opencog)
 (opencog exec)
 (opencog python))

(python-eval "

from opencog.type_constructors import *

def sum(num1, num2):
   n1 = float(num1.name)
   n2 = float(num2.name)
   return NumberNode(str(n1+n2))

")

(display
 (cog-execute!
  (ExecutionOutputLink
   (GroundedSchemaNode "py: sum")
   (ListLink
    (Number 1)
    (Number 2)))))
