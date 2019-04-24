(use-modules
 (opencog)
 (opencog exec)
 (opencog nlp)
 (opencog nlp chatbot)
 (opencog nlp relex2logic))

(define work-rule
 (Bind
  (VariableList
   (TypedVariable
    (Variable "$verb_inst")
    (Type "PredicateNode"))
   (TypedVariable
    (Variable "$who_concept_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$who_concept")
    (Type "ConceptNode")))
  (And
   (ImplicationLink
    (Variable "$verb_inst")
    (PredicateNode "work"))
   (InheritanceLink
    (Variable "$who_concept_inst")
    (Variable "$who_concept"))
   (EvaluationLink
    (Variable "$verb_inst")
    (ListLink
     (Variable "$who_concept_inst"))))
  (Evaluation
   (Predicate "work")
   (List
    (Variable "$who_concept")))))


(nlp-parse "I work in SoftMegaCorp.")
;(nlp-parse "Bob is my colegue.")

;(cog-prt-atomspace)

(display
 (cog-execute! work-rule))