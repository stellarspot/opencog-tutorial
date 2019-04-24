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

(define colegue-rule
 (Bind
  (VariableList
   ; colegue
   (TypedVariable
    (Variable "$colegue_inst")
    (Type "ConceptNode"))
   ; who
   (TypedVariable
    (Variable "$who_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$who")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$who_specific")
    (Type "SpecificEntityNode"))
   ; whom
   (TypedVariable
    (Variable "$whom_inst")
    (Type "ConceptNode"))
   (TypedVariable
    (Variable "$whom")
    (Type "ConceptNode")))
  (And
   (InheritanceLink
    (Variable "$colegue_inst")
    (ConceptNode "colegue"))
   (InheritanceLink
    (Variable "$who_inst")
    (Variable "$who"))
   (InheritanceLink
    (Variable "$whom_inst")
    (Variable "$whom"))
   ; restrict parents of who in InheritanceLink
   ; only to SpecificEntityNode
   (InheritanceLink
    (Variable "$who_specific")
    (Variable "$who"))
   (InheritanceLink
    (Variable "$who_inst")
    (Variable "$colegue_inst"))
   (EvaluationLink
    (DefinedLinguisticPredicateNode "possession")
    (ListLink
     (Variable "$colegue_inst")
     (Variable "$whom_inst"))))
  (Evaluation
   (Predicate "colegue")
   (List
    (Variable "$who")
    (Variable "$whom")))))


(nlp-parse "I work in SoftMegaCorp.")
(nlp-parse "Bob is my colegue.")

;(cog-prt-atomspace)

(display
 (cog-execute! work-rule))

(display
 (cog-execute! colegue-rule))