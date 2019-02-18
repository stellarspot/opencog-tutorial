# OpenCog tutorial


## Atomese

### Scheme

```scheme
; import opencog libraries
(use-modules (opencog))

```

### Python

```python
from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.atomspace import TruthValue

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)
```

## Nodes

### ConceptNode

```scheme
(Concept "cat")
(Concept "green")
(Concept "ball")
```

```python
ConceptNode("cat")
ConceptNode("green")
ConceptNode("ball")
```

## Values

### StringValue

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

```python

from opencog.atomspace import PtrValue
import numpy as np

# Matrix
# (0, 1)
# (1, 0)
matrix = np.array([0, 1, 1, 0]).reshape([2, 2])

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



## Pattern Matcher

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