# OpenCog tutorial


## Atomese

### Scheme

```scheme
; import opencog libraries
(use-modules (opencog) (opencog exec))

```

Use logger:
```scheme
(use-modules (opencog logger))
(cog-logger-set-level! "debug")
```

Print all atoms in the atomspace:
```scheme
(cog-prt-atomspace)
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

Print all atoms in the atomspace:
```python
for atom in atomspace:
    if not atom.incoming:
        print(str(atom))
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
### GroundedObjectNode

```python
# Class to be stored in GroundedObjectNode
class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def get_x(self):
        return self.x

    def get_y(self):
        return self.x

    def move(self, x, y):
        self.x += x
        self.y += y

    def __str__(self):
        return "Point(%d, %d)" % (self.x, self.y)


point = Point(2, 3)
print("point:", point)

GroundedObjectNode("point", point, unwrap_args=True)

apply_link = ApplyLink(
    MethodOfLink(
        GroundedObjectNode("point"),
        ConceptNode("move")
    ),
    ListLink(
        GroundedObjectNode("x", 3),
        GroundedObjectNode("y", 4)
    )
)

execute_atom(atomspace, apply_link)

print("point:", point)
```

Output:
```text
point: Point(2, 3)
point: Point(5, 7)
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

## DeleteLink

Removes atoms from the AtomSpace.

Scheme:
```scheme
(use-modules (opencog) (opencog exec))

(Inheritance
 (Concept "apple-1")
 (Concept "apple"))

(Inheritance
 (Concept "apple-2")
 (Concept "apple"))

(define (get-apples)
 (cog-execute!
  (Get
   (Inheritance
    (Variable "$APPLE")
    (Concept "apple")))))

(display (get-apples))

(Delete
 (Inheritance
  (Concept "apple-1")
  (Concept "apple")))

(display (get-apples))

```

Output:
```scheme
(SetLink
   (ConceptNode "apple-1")
   (ConceptNode "apple-2")
)
(SetLink
   (ConceptNode "apple-2")
)
```


Python:
```python
ConceptNode("node-1")
ConceptNode("node-2")
print("nodes in atomspace:", atomspace.size())

DeleteLink(ConceptNode("node-1"))
print("nodes in atomspace:", atomspace.size())

DeleteLink(ConceptNode("node-2"))
print("nodes in atomspace:", atomspace.size())
```

Output:
```scheme
nodes in atomspace: 2
nodes in atomspace: 1
nodes in atomspace: 0
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

Find all red balls.

Scheme:
```scheme
(define red (Concept "red"))
(define green (Concept "green"))

(Inheritance (ConceptNode "ball1") red)
(Inheritance (ConceptNode "ball2") green)
(Inheritance (ConceptNode "ball3") red)
(Inheritance (ConceptNode "ball4") green)


(define red-balls-rule
 (Get
  (Inheritance
   (Variable "$BALL")
   red)))

(display
 (cog-execute! red-balls-rule))
```

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

### BindLink

Put red balls to the basket1 and green balls to the basket2

Scheme:
```scheme
(define red (Concept "red"))
(define green (Concept "green"))

(Inheritance (ConceptNode "ball1") red)
(Inheritance (ConceptNode "ball2") green)
(Inheritance (ConceptNode "ball3") red)

(define basket1 (Concept "basket1"))
(define basket2 (Concept "basket2"))


(define (put-balls-to-basket basket color)
 (Bind
  (VariableList
   (TypedVariable
    (Variable "$BALL")
    (Type "ConceptNode")))
  (Inheritance
   (Variable "$BALL")
   color)
  (Member
   (Variable "$BALL")
   basket)))

(display
 (cog-execute! (put-balls-to-basket basket1 red)))

(display
 (cog-execute! (put-balls-to-basket basket2 green)))
```

Output:
```scheme

(SetLink
   (MemberLink
      (ConceptNode "ball1")
      (ConceptNode "basket1")
   )
   (MemberLink
      (ConceptNode "ball3")
      (ConceptNode "basket1")
   )
)
(SetLink
   (MemberLink
      (ConceptNode "ball2")
      (ConceptNode "basket2")
   )
)
```

## URE

### Simple Deduction example:

* Scheme:
  * [Rules and Config](examples/ure/scheme/example-deduction.scm)
  * [Forward Chainer](examples/ure/scheme/example-fc-deduction.scm)
  * [Backward Chainer](examples/ure/scheme/example-fc-deduction.scm)
* Python:
  * [Rules and Config](examples/ure/python/example_deduction.py)
  * [Forward Chainer](examples/ure/python/example_fc_deduction.py)
  * [Backward Chainer](examples/ure/python/example_bc_deduction.py)


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

## Natural Language Processing

Parse sentence:
```scheme
(nlp-parse "I like cats.")
```

### Surface Realization (SuReal)

Create sentence:
```scheme
(nlp-parse "He eats.")
(nlp-parse "She eats quickly.")
(nlp-parse "Nobody drank it.")
(nlp-parse "It drinks water.")

(display
 (sureal
  (SetLink
   (EvaluationLink
    (PredicateNode "drink")
    (ListLink (ConceptNode "she"))))))

(newline)

(display
 (sureal
  (SetLink
   (EvaluationLink
    (PredicateNode "drink")
    (ListLink (ConceptNode "she")))
   (InheritanceLink
    (PredicateNode "drink")
    (DefinedLinguisticConceptNode "past")))))

(newline)
```

Output:
```scheme
((she drinks .))
((she drank it .))
```


### PLN:
```scheme
(nlp-parse "Dogs can bark.")
(nlp-parse "Tobby is a dog.")

; Load rule-base for the trail of inference
(load-trail-3)
(do_pln)

; Utility for testing as sureal part is broken
(define (get-atoms-for-sureal trail)
 (define pln-outputs (cog-value->list
                      (cog-value trail (Predicate "inference-results"))))
 (if (null? pln-outputs) '() (cog-outgoing-set (filter-for-sureal pln-outputs))))


(display
 (get-atoms-for-sureal rb-trail-3))
```

Output:
```scheme
((EvaluationLink
   (PredicateNode "bark" (stv 9.7e-13 0.001))
   (ListLink (etv 1 0)
      (ConceptNode "Tobby" (stv 9.7e-13 0.001))
   )
)
```

## GHOST

```scheme
; Python methods

(python-eval "

from opencog.atomspace import types
from opencog.type_constructors import *
from opencog.scheme_wrapper import scheme_eval_as
from opencog.cogserver_type_constructors import *

atomspace = scheme_eval_as('(cog-atomspace)')
set_type_ctor_atomspace(atomspace)

# animal is a WordNode or a ListLink which consists of WordNodes
def get_legs(animal):
    word = animal.get_out()[0] if animal.type == types.ListLink else animal
    legs_table = {'lion': 4, 'flamingo': 2}
    legs = legs_table.get(word.name)
    return WordNode(str(legs) if legs else 'may be 3')
")

; Ghost methods

(define-public
 (call_animal animal)
 (List animal animal animal))

; Ghost Rules
(ghost-parse "
concept: ~bird [flamingo swan]
concept: ~reptile [turtle snake]
concept: ~mammal [lion leopard elephant]
concept: ~animal [~bird ~reptile ~mammal]
concept: ~dangerous_animal [lion snake]

concept: ~attitude [like hate]

p: Welcome to the Zoo! Which animals do you want to see?
  j1: (see ~bird) Birds are so beautiful. Let's go to see them!
  j1: (see ~reptile) Good choice. Let's go to see reptiles!

r: (do you ~attitude _~bird) $animal='_0 I am a fun of $animal!

r: (do you ~attitude _~reptile) $animal='_0 I am afraid of $animal!

r: (what is amusing _~animal)
    $animal='_0
    Just call it ^call_animal($animal)! # Call Scheme method

r: (legs does _~animal have)
    $animal='_0
    $animal has ^py_get_legs($animal) legs # Call Python method using 'py_' prefix.
")

; Test Ghost
(test-ghost "Hello")
;[Ghost] (Welcome to the Zoo ! Which animals do you want to see ?)
(test-ghost "I want to see flamingo")
;[Ghost]  (Birds are so beautiful. Let's go to see them !)

(test-ghost "Hi")
;[Ghost] (Welcome to the Zoo ! Which animals do you want to see ?)
(test-ghost "I want to see turtle")
;[Ghost] (Good choice. Let's go to see reptiles !)

(test-ghost "Do you like swans?")
;[Ghost] (I am a fun of swans !)

(test-ghost "Do you hate snakes?")
;[Ghost] (I am afraid of snakes !)

(test-ghost "What is amusing elephant!")
;[Ghost] (Just call it elephant elephant elephant !)

(test-ghost "How many legs does lion have?")
;[Ghost] (lion has 4 legs)
```

## Scheme Python Interoperability

### Call Python from Scheme

Putting Python code as a string into Scheme file:
```scheme
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
```

Call Python method from Scheme

Python sample_python_code.py file:
```python
from opencog.type_constructors import *


def mul(num1, num2):
    n1 = float(num1.name)
    n2 = float(num2.name)
    return NumberNode(str(n1 * n2))
```
Scheme file:
```scheme
(use-modules
 (opencog)
 (opencog exec)
 (opencog python))

(python-eval "exec(open('example_python_code.py').read())")

(display
 (cog-execute!
  (ExecutionOutputLink
   (GroundedSchemaNode "py: mul")
   (ListLink
    (Number 2)
    (Number 3)))))
```

### Call Scheme from Python

```python
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
```

Output:
```text
value: (StringValue "sample-value")
```