(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)

 ; Python bindings
 (opencog exec)
 (opencog python))

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