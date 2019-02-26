(use-modules (opencog) (opencog exec))

(define key (Predicate "key"))
(define atom (Concept "atom"))
(cog-set-value! atom key (FloatValue 3))

(display
 (cog-execute! (ValueOf atom key))
)