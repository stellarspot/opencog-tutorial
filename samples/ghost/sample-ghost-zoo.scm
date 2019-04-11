(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)

 ; Python bindings
 (opencog exec)
 (opencog python)

)

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

(define-public
 (how_many_legs animal)
 (define legs
  (cog-execute!
   (ExecutionOutputLink
    (GroundedSchemaNode "py: get_legs")
    (ListLink animal))))
 (List legs))

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

r: (what is amusing _~animal) $animal='_0 Just call it ^call_animal($animal)!

r: (legs does _~animal have)
    $animal='_0
    $animal has ^how_many_legs($animal) legs
")

; Test Ghost
(test-ghost "Hello")
(test-ghost "I want to see flamingo")

(test-ghost "Hi")
(test-ghost "I want to see turtle")

(test-ghost "Do you like swans?")
(test-ghost "Do you hate snakes?")
(test-ghost "What is amusing elephant!")
(test-ghost "How many legs does lion have?")