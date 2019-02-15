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