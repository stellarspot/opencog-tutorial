(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)

 (opencog exec)
)

; Legend 1:
; I work in SoftMegaCorp.
; Q: Where do I work?
; A: You work in SoftMegaCorp.

; Legend 2:
; Alice work in HardMegaCorp.
; Q: Where does Alice work?
; A: Alice works in HardMegaCorp.

; Legend 3:
; I work in SoftMegaCorp.
; Alice works in HardMegaCorp.
; Bob is my colegue.
; Q: Where does Bob work?
; A: Bob work in SoftMegaCorp.

; Parse facts rules

(define parse-facts-work-rule
 (Bind
  (VariableList
   ; verb
   (TypedVariable
    (Variable "$verb_inst")
    (Type "PredicateNode"))
   ; who
   (TypedVariable
    (Variable "$who_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$who")
    (Type "ConceptNode"))
   ; preposition
   (TypedVariable
    (Variable "$preposition_inst")
    (Type "PredicateNode"))
   ; where
   (TypedVariable
    (Variable "$where_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$where")
    (Type "ConceptNode")))
  (And
   (ImplicationLink
    (Variable "$verb_inst")
    (PredicateNode "work"))
   (InheritanceLink
    (Variable "$who_inst")
    (Variable "$who"))
   (InheritanceLink
    (Variable "$where_inst")
    (Variable "$where"))
   (EvaluationLink
    (Variable "$verb_inst")
    (ListLink
     (Variable "$who_inst")))
   (EvaluationLink
    (Variable "$preposition_inst")
    (ListLink
     (Variable "$verb_inst")
     (Variable "$where_inst"))))
  (Evaluation
   (Predicate "work")
   (List
    (Variable "$who")
    (Variable "$where")))))


; Ghost methods

(define-public
 (parse-facts)
 (cog-execute! parse-facts-work-rule)
 (List))

;; Ghost Rules
(ghost-parse "

p: This is your personal Notebook assistant

r: (I work in _*)
  '_0 is a great company!
  ^parse-facts()
  ^keep()

r: (where do _* work) Just try to find where '_0 work.
  ^keep()
")

; Test Ghost
(test-ghost "I work in SoftMegaCorp.")
(test-ghost "Where do I work?")

;(cog-prt-atomspace)