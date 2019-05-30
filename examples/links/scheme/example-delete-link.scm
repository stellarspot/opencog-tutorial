(use-modules (opencog) (opencog exec))

(Inheritance
 (Concept "apple-1")
 (Concept "apple"))

(Inheritance
 (Concept "apple-2")
 (Concept "apple"))

(define (get-apples)
 (cog-execute!
  (Get
   (Inheritance
    (Variable "$APPLE")
    (Concept "apple")))))

(display (get-apples))

(Delete
 (Inheritance
  (Concept "apple-1")
  (Concept "apple")))

(display (get-apples))
