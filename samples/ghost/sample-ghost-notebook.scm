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

; Legend 1:
; I work in SoftMegaCorp.
; Q: Where do I work?
; A: You work in SoftMegaCorp.

; Legend 2:
; I work in SoftMegaCorp.
; Alice works in HardMegaCorp.
; Bob is my colegue.
; Q: Where does Bob work?
; A: Bob work in SoftMegaCorp.

; Python methods

(python-eval "

from opencog.atomspace import types
from opencog.type_constructors import *
from opencog.scheme_wrapper import scheme_eval_as
from opencog.cogserver_type_constructors import *

atomspace = scheme_eval_as('(cog-atomspace)')
set_type_ctor_atomspace(atomspace)

")

; Ghost methods

;; Ghost Rules
(ghost-parse "

p: This is your personal Notebook assistant
")

; Test Ghost
(test-ghost "I work in SoftMegaCorp.")

;(cog-prt-atomspace)