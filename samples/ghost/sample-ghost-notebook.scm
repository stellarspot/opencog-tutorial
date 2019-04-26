(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog openpsi)
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
; Bob is my colleague.
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

(define-public (where-somebody-work who-list)
 (define who (get-first-element-from-set who-list))
 ; Workaround for passed i instead of I
 ; and alice instead of Alice
 (define who-name (string-upcase (cog-name who) 0 1))
 (define where-set
  (cog-execute!
   (Get
    (Evaluation
     (Predicate "work")
     (ListLink
      (Concept who-name)
      (Variable "$where"))))))
 (Word (cog-name (get-first-element-from-set where-set))))

(define (get-first-element-from-set set)
 (define outgoing-set (cog-outgoing-set set))
 (if (null? outgoing-set)
  (Concept "Unknown")
  (car outgoing-set)))


;; Ghost Rules
(ghost-parse "

# Disable gambit
# p: This is your personal Notebook assistant

r: (* [work works] in _*)
  ['_0 is a great company!]
  ['_0 is a fantastic company!]
  ^parse-facts()
  ^keep()

r: (where [do does] _* work) '_0 work in ^where-somebody-work('_0) company.
  ^keep()
")

; Disable the ECAN related config for now
(ghost-set-sti-weight 0)
(ghost-af-only #f)

(ghost-set-refractory-period .01)

; Actually start Ghost
(ghost-run)

; Test Ghost
(ghost "I work in SoftMegaCorp.")
(ghost "Where do I work?")

; Wait for the refractory period
(sleep 1)
(ghost "Alice works in HardMegaCorp.")
(ghost "Where does Alice work?")

;(cog-prt-atomspace)