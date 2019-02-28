# OpenCog tutorial


## Atomese

### Scheme

```scheme
; import opencog libraries
(use-modules (opencog) (opencog exec))

```

### Python

```python
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom
from opencog.atomspace import TruthValue

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)
```

## Nodes

### ConceptNode

Scheme:
```scheme
(Concept "cat")
(Concept "green")
(Concept "ball")
```

Python:
```python
ConceptNode("cat")
ConceptNode("green")
ConceptNode("ball")
```

### NumberNode

Scheme:
```scheme
(Number 3)
(Number 4)
```

```python
NumberNode("3")
NumberNode("4")
```
## Values

### StringValue

Python:
```python
string_key = ConceptNode("string-key")
string_node = ConceptNode("String")
string_node.set_value(string_key, StringValue("Hello, World!"))

string_value = string_node.get_value(string_key)
print(string_value.to_list())

string_node.set_value(string_key, StringValue(["Hello", "Opencog!"]))
string_value = string_node.get_value(string_key)
print(string_value.to_list())
```
Output:
```text
['Hello, World!']
['Hello', 'Opencog!']
```

### FloatValue

### PtrValue

PrtValue allows to store native objects as vales in OpenCog atoms.

Example of storing a matrix as an atom value:

Python:
```python
from opencog.atomspace import PtrValue
import numpy as np

# Matrix
# (0, 1)
# (1, 0)
matrix = np.matrix([[0, 1], [1, 0]])

matrix_key = ConceptNode("matrix-ket")
matrix_node = ConceptNode("Matrix")
matrix_node.set_value(matrix_key, PtrValue(matrix))

matrix_value = matrix_node.get_value(matrix_key)

print(matrix_value.value())
```

Output:
```text
[[0 1]
 [1 0]]
```

## Links

### ArityLink

Python:
```python
arity_link = ArityLink(
    ListLink(
        ConceptNode("apple"),
        ConceptNode("orange"),
        ConceptNode("pear")))

res = execute_atom(atomspace, arity_link)
print(res)
```
Output:
```scheme
(NumberNode "3.000000")
```

### LambdaLink

Scheme:
```scheme
(Define
 (DefinedSchema "add")
 (Lambda
  (VariableList
   (Variable "$X")
   (Variable "$Y"))
  (Plus
   (Variable "$X")
   (Variable "$Y"))))

(display
 (cog-execute!
  (ExecutionOutput
   (DefinedSchema "add")
   (List
    (Number "2")
    (Number "3")))))
```
Output: ```(NumberNode "5.000000")```

Python:
```python
(DefineLink(
    DefinedSchemaNode('add'),
    LambdaLink(
        VariableList(
            VariableNode('$X'),
            VariableNode('$Y')),
        PlusLink(
            VariableNode('$X'),
            VariableNode('$Y')))))

res = execute_atom(atomspace,
                   ExecutionOutputLink(
                       DefinedSchemaNode('add'),
                       ListLink(
                           NumberNode('3'),
                           NumberNode('4'))))
print(res)
```

Output:
```scheme
(ExecutionOutputLink
  (DefinedSchemaNode "add")
  (ListLink
    (NumberNode "3.000000")
    (NumberNode "4.000000")
  )
)
```

### ExecutionOutputLink

Python:
```python
def pow(node_a, node_b):
    a = int(float(node_a.name))
    b = int(float(node_b.name))
    return NumberNode(str(a ** b))


execution_output_link = ExecutionOutputLink(
    GroundedSchemaNode("py: pow"),
    ListLink(
        NumberNode("2"),
        NumberNode("5")
    ))

res = execute_atom(atomspace, execution_output_link)
print(res)
```
Output:
```scheme
(NumberNode "32.000000")
```

### ValueOfLink

Scheme:
```scheme
(define key (Predicate "key"))
(define atom (Concept "atom"))
(cog-set-value! atom key (FloatValue 3))

(display
 (cog-execute! (ValueOf atom key))
)
```
Output:
```scheme
(FloatValue 3)
```

Python:
```python
key = PredicateNode("key")
atom = ConceptNode("atom")
atom.set_value(key, FloatValue(3))

value_of_link = ValueOfLink(atom, key)

res = execute_atom(atomspace, value_of_link)
print(res)
```

Output:
```scheme
(FloatValue 3)
```

## Pattern Matcher

### GetLink

Find all red balls sample.

Python:
```python
red = ConceptNode("red")
green = ConceptNode("green")

InheritanceLink(ConceptNode("ball1"), red)
InheritanceLink(ConceptNode("ball2"), green)
InheritanceLink(ConceptNode("ball3"), red)
InheritanceLink(ConceptNode("ball4"), green)

red_balls_rule = GetLink(
    InheritanceLink(
        VariableNode("$BALL"),
        red))

res = execute_atom(atomspace, red_balls_rule)
print(res)
```
Output:
```scheme
(SetLink
  (ConceptNode "ball1")
  (ConceptNode "ball3")
)
```

### PutLink

Python:
```python
put_link = PutLink(
    InheritanceLink(ConceptNode("ball"), VariableNode("$COLOR")),
    ConceptNode("orange")
)

res = execute_atom(atomspace, put_link)
print(res)
```
Output:
```scheme
(InheritanceLink
  (ConceptNode "ball")
  (ConceptNode "orange")
)
```

## URE

### Simple Deduction example:

* Scheme:
  * [Rules and Config](samples/ure/scheme/sample-deduction.scm)
  * [Forward Chainer](samples/ure/scheme/sample-fc-deduction.scm)
  * [Backward Chainer](samples/ure/scheme/sample-fc-deduction.scm)
* Python:
  * [Rules and Config](samples/ure/python/sample_deduction.py)
  * [Forward Chainer](samples/ure/python/sample_fc_deduction.py)
  * [Backward Chainer](samples/ure/python/sample_bc_deduction.py)


### Forward Chainer

Enable retry exhausted sources.
Scheme:

```scheme
;; Define a new rule base (aka rule-based system)
(define deduction-rbs (ConceptNode "deduction-rule-base"))

(ure-set-fc-retry-exhausted-sources deduction-rbs #t)

```
Python:
```python

deduction_rbs = ConceptNode("deduction-rule-base")

EvaluationLink(
    PredicateNode("URE:FC:retry-exhausted-sources"),
    deduction_rbs
).tv = TruthValue(1, 1)
```