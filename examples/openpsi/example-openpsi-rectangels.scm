(use-modules
 (opencog)
 (opencog exec)
 (opencog openpsi))

; Find the same rectangles by OpenPsi
; Mark iterated rectangles as handled

; Utility atoms and methods
(define parent-rect (Concept "rectangle"))
(define key-cornes (Concept "key-corners"))

(define (add-rect id name x1 y1 x2 y2)
 (define rect (Concept name))
 (cog-set-value! rect key-cornes (FloatValue x1 y1 x2 y2))
 (Set
  (Inheritance rect parent-rect)
  (Evaluation
   (Predicate "id")
   (List
    (Number id)
    rect))))

(define (handled-rect rect)
 (Evaluation
  (Predicate "handled-rect")
  rect))

; OpenPsi components

; OpenPsi Goal
(define goal-find-the-same-rects
 (Concept "goal-find-the-same-rects"))

; OpenPsi context
; Find the same rectangles pattern
(define context-find-the-same-rects
 (list
  (Evaluation
   (Predicate "id")
   (List
    (Variable "$ID_1")
    (Variable "$RECT_1")))
  (Inheritance (Variable "$RECT_1") parent-rect)
  (Absent
   (handled-rect (Variable "$RECT_1")))
  (Evaluation
   (Predicate "id")
   (List
    (Variable "$ID_2")
    (Variable "$RECT_2")))
  (Inheritance (Variable "$RECT_2") parent-rect)
  (Absent
   (handled-rect (Variable "$RECT_2")))
  (Not
   (Equal
    (Variable "$RECT_1")
    (Variable "$RECT_2")))
  (Evaluation
   (GroundedPredicateNode "scm: check-the-same-rects")
   (List
    (Variable "$RECT_1")
    (Variable "$RECT_2")))))

(define (check-the-same-rects rect1 rect2)
 (define rects-equals
  (equal?
   (cog-value rect1 key-cornes)
   (cog-value rect2 key-cornes)))
 (if rects-equals (stv 1 1) (stv 0 1)))

; OpenPsi action
; Do something with the same rectangles
; and mark them as handled
(define action-find-the-same-rects
 (ExecutionOutput
  (GroundedSchema "scm: find-the-same-rects")
  (List
   (List
    (Variable "$RECT_1")
    (Variable "$RECT_2")))))

(define (find-the-same-rects groundings)
 (define rect1 (car (cog-outgoing-set groundings)))
 (define rect2 (cadr (cog-outgoing-set groundings)))
 ; Do something with the same rectangles
 (display "[openpsi] find-the-same-rects\n")
 (display rect1)
 (display rect2)
 ; Set rects as handled
 (Set
  (handled-rect rect1)
  (handled-rect rect2)))

; OpenPsi component
; It is used to run and stop OpenPsi
(define component-find-the-same-rects
 (psi-component "component-find-the-same-rects"))

(define rule-1
 (psi-rule
  context-find-the-same-rects
  action-find-the-same-rects
  goal-find-the-same-rects
  (stv 1 1)
  component-find-the-same-rects))


; OpenPsi circle.
; Run OpenPsi, add rectangles to handle by OpenPsi and stop it.

(define delay 500000)

; Run OpenPsi
(psi-run component-find-the-same-rects)

; Add rectangles to Atomspace
; Rectangles (rect-1, rect-3) and (rect-2, rect5) are the same

(add-rect 1 "rect-1" 100 100 200 200)
(add-rect 2 "rect-2" 100 100 400 400)
(add-rect 3 "rect-3" 100 100 200 200)

(usleep delay)
(add-rect 4 "rect-4" 200 200 400 400)

(usleep delay)
(add-rect 5 "rect-5" 100 100 400 400)
(usleep delay)

; Stop OpenPsi
(psi-halt component-find-the-same-rects)