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
    (Type "WordInstanceNode"))
   (TypedVariable
    (Variable "$verb_pred")
    (Type "PredicateNode"))
   (TypedVariable
    (Variable "$who_concept_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$who_concept")
    (Type "ConceptNode")))
  (And
   (ReferenceLink
    (Variable "$verb_inst")
    (WordNode "work"))
   (ReferenceLink
    (Variable "$verb_pred")
    (Variable "$verb_inst"))
   (InheritanceLink
    (Variable "$who_concept_inst")
    (Variable "$who_concept"))
   (EvaluationLink
    (Variable "$verb_pred")
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