(use-modules
 (opencog)
 (opencog openpsi))

; OpenPsi sample
; Eat apples

(define apple (Concept "apple"))

; OpenPsi Goal: eat apples
(define goal
 (Concept "goal-eat-apples"))

(define context
 (list
  (Inheritance (Variable "$APPLE") apple)))

; OpenPsi Action: eat apple
(define action
 (ExecutionOutput
  (GroundedSchema "scm: eat-apple")
  (List
   (Variable "$APPLE")
  )))

(define (eat-apple apple)
 (display "[openpsi] eat apple action\n")
 (display apple)
 (ConceptNode "finished"))

; OpenPsi component
(define component (psi-component "component"))

; OpenPsi Rule: Eat apple
(define rule
 (psi-rule
  context
  action
  goal
  (stv 1 1)
  component))

(define delay 100000)
; Run OpenPsi
(psi-run component)

(Inheritance (Concept "apple-1") apple)
(usleep delay)

(Inheritance (Concept "apple-2") apple)
(usleep delay)

; Stop OpenPsi
(psi-halt component)