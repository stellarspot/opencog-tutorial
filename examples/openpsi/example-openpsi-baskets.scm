(use-modules
 (opencog)
 (opencog openpsi))

(define red (Concept "red"))
(define green (Concept "green"))

(define ball1 (Concept "ball1"))
(define ball2 (Concept "ball2"))
(define ball3 (Concept "ball3"))
(define ball4 (Concept "ball4"))
(define ball5 (Concept "ball5"))
(define ball6 (Concept "ball6"))

(Inheritance ball1 red)
(Inheritance ball2 red)
(Inheritance ball3 red)
(Inheritance ball4 green)
(Inheritance ball5 green)
(Inheritance ball6 green)

(define basket (Concept "basket"))

(define basket1 (Concept "basket1"))
(define basket2 (Concept "basket2"))
(define basket3 (Concept "basket3"))

(Inheritance basket1 basket)
(Inheritance basket2 basket)
(Inheritance basket3 basket)

(Member ball1 basket1)
(Member ball2 basket1)
(Member ball3 basket2)
(Member ball4 basket2)
(Member ball5 basket3)
(Member ball6 basket3)

(define goal-count-green-balls
 (Concept "goal-count-green-balls"))

(define context-count-green-balls
 (list
  (Member
   (Variable "$BALL")
   (Variable "$BASKET"))
  (Inheritance
   (Variable "$BALL")
   green)
  (Inheritance
   (Variable "$BASKET")
   basket)))

(define action-count-green-balls
 (ExecutionOutput
  (GroundedSchema "scm: count-green-balls")
  (List
   (List
    (Variable "$BALL")
    (Variable "$BASKET")))))

(define (count-green-balls groundings)
 (display "[openpsi] count green ball action\n")
 (display groundings)
 (ConceptNode "count-green-balls")
)

(define component-count-green-balls (psi-component "component-count-green-balls"))

(define rule-1
 (psi-rule
  context-count-green-balls
  action-count-green-balls
  goal-count-green-balls
  (stv 1 1)
  component-count-green-balls))

(psi-run component-count-green-balls)
(usleep 100000)
(psi-halt component-count-green-balls)