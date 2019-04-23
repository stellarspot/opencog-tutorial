(use-modules (opencog) (opencog exec))

(define red (Concept "red"))
(define green (Concept "green"))

(Inheritance (ConceptNode "ball1") red)
(Inheritance (ConceptNode "ball2") green)
(Inheritance (ConceptNode "ball3") red)

(define basket1 (Concept "basket1"))
(define basket2 (Concept "basket2"))


(define (put-balls-to-basket basket color)
 (Bind
  (VariableList
   (TypedVariable
    (Variable "$BALL")
    (Type "ConceptNode")))
  (Inheritance
   (Variable "$BALL")
   color)
  (Member
   (Variable "$BALL")
   basket)))

(display
 (cog-execute! (put-balls-to-basket basket1 red)))

(display
 (cog-execute! (put-balls-to-basket basket2 green)))