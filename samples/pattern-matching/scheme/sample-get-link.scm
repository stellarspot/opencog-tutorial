(use-modules (opencog) (opencog exec))

(define red (Concept "red"))
(define green (Concept "green"))

(Inheritance (ConceptNode "ball1") red)
(Inheritance (ConceptNode "ball2") green)
(Inheritance (ConceptNode "ball3") red)
(Inheritance (ConceptNode "ball4") green)


(define red-balls-rule
 (Get
  (Inheritance
   (Variable "$BALL")
   red)))

(display
 (cog-execute! red-balls-rule))
