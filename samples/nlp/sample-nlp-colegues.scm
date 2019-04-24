(use-modules
 (opencog)
 (opencog exec)
 (opencog nlp)
 (opencog nlp chatbot)
 (opencog nlp relex2logic))

(define work-rule
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


(nlp-parse "I work in SoftMegaCorp.")
;(nlp-parse "Bob is my colegue.")

;(cog-prt-atomspace)

(display
 (cog-execute! work-rule))