(use-modules (opencog) (opencog exec) (opencog rule-engine))

(load "sample-deduction.scm")

;;;;;;;;;;;;;;;;;;;;
;; Knowledge Base ;;
;;;;;;;;;;;;;;;;;;;;

(define A (ConceptNode "A" (stv 1 1)))
(define B (ConceptNode "B"))
(define C (ConceptNode "C"))
(define AB (InheritanceLink (stv 1 1) A B))
(define BC (InheritanceLink (stv 1 1) B C))

;;;;;;;;;;;;;;;;;;;;;
;; Forward Chainer ;;
;;;;;;;;;;;;;;;;;;;;;

(display
 (cog-fc
  fc-deduction-rbs
  (InheritanceLink (VariableNode "$X") C)
  #:vardecl (TypedVariable (VariableNode "$X") (TypeNode "ConceptNode"))))
