(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp sureal)
 (opencog nlp chatbot)
 (opencog nlp relex2logic))

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
