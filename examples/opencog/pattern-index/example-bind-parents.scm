(use-modules (opencog) (opencog exec))

(Inheritance (Concept "John") (Concept "human"))
(Inheritance (Concept "John") (Concept "male"))

(Inheritance (Concept "Jane") (Concept "human"))
(Inheritance (Concept "Jane") (Concept "female"))

(Inheritance (Concept "Alice") (Concept "human"))
(Inheritance (Concept "Alice") (Concept "female"))

(Inheritance (Concept "Bob") (Concept "human"))
(Inheritance (Concept "Bob") (Concept "male"))

(Inheritance (Concept "Peter") (Concept "human"))
(Inheritance (Concept "Peter") (Concept "male"))

(Evaluation
 (Predicate "married")
 (List
  (Concept "John")
  (Concept "Jane")))

(Evaluation
 (Predicate "married")
 (List
  (Concept "Alice")
  (Concept "Bob")))


(Inheritance
 (Concept "Alice")
 (Concept "John"))

(Inheritance (Concept "Alice") (Concept "Jane"))
(Inheritance (Concept "Peter") (Concept "Alice"))
(Inheritance (Concept "Peter") (Concept "Bob"))


(define query-son
 (Bind
  (VariableList
   (Variable "$SON")
   (Variable "$PARENT"))
  (And
   (Inheritance (Variable "$PARENT") (Concept "human"))
   (Inheritance (Variable "$SON") (Concept "human"))
   (Inheritance (Variable "$SON") (Concept "male"))
   (Inheritance (Variable "$SON") (Variable "$PARENT")))
  (Variable "$SON")))

(display
 (cog-execute! query-son))