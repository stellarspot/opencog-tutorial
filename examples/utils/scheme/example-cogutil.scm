(use-modules (opencog) (opencog exec))

; cog-chase-link

(EvaluationLink
 (PredicateNode "red")
 (ConceptNode "ball-1"))

(EvaluationLink
 (PredicateNode "big")
 (ConceptNode "ball-1"))

(EvaluationLink
 (PredicateNode "green")
 (ConceptNode "ball-2"))

(EvaluationLink
 (PredicateNode "small")
 (ConceptNode "ball-2"))

(display
 (cog-chase-link 'EvaluationLink 'PredicateNode (ConceptNode "ball-2")))
