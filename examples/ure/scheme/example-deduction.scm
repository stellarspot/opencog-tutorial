(use-modules (opencog) (opencog exec) (opencog rule-engine))

;; =============================================================================
;; Crisp logic entailment (Deduction) Rule.
;;
;;   A->B
;;   B->C
;;   |-
;;   A->C
;;
;; See https://github.com/opencog/atomspace/tree/master/examples/rule-engine for more details.
;; -----------------------------------------------------------------------------

(define deduction-rule
 (BindLink
  (VariableList
   (TypedVariableLink
    (VariableNode "$A")
    (TypeNode "ConceptNode"))
   (TypedVariableLink
    (VariableNode "$B")
    (TypeNode "ConceptNode"))
   (TypedVariableLink
    (VariableNode "$C")
    (TypeNode "ConceptNode")))
  (AndLink
   (InheritanceLink
    (VariableNode "$A")
    (VariableNode "$B"))
   (InheritanceLink
    (VariableNode "$B")
    (VariableNode "$C"))
   ;; To avoid matching (Inheritance A B) and (Inheritance B A)
   (NotLink
    (IdenticalLink
     (VariableNode "$A")
     (VariableNode "$C"))))
  (ExecutionOutputLink
   (GroundedSchemaNode "scm: deduction-formula")
   (ListLink
    (InheritanceLink
     (VariableNode "$A")
     (VariableNode "$C"))
    (InheritanceLink
     (VariableNode "$A")
     (VariableNode "$B"))
    (InheritanceLink
     (VariableNode "$B")
     (VariableNode "$C"))))))


;; -----------------------------------------------------------------------------
;; Deduction Formula
;;
;; If both confidence and strength of A->B and B->C are above 0.5 then
;; set the TV of A->C to (stv 1 1)
;; -----------------------------------------------------------------------------

(define (deduction-formula AC AB BC)
 (let (
        (sAB (cog-stv-strength AB))
        (cAB (cog-stv-confidence AB))
        (sBC (cog-stv-strength BC))
        (cBC (cog-stv-confidence BC)))
  (if (and (>= sAB 0.5) (>= cAB 0.5) (>= sBC 0.5) (>= cBC 0.5))
   (cog-set-tv! AC (stv 1 1)))))

;; Associate a name to the rule
(define deduction-rule-name
 (DefinedSchemaNode "deduction-rule"))

(DefineLink
 deduction-rule-name
 deduction-rule)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Associate rules to PLN ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define a new rule base (aka rule-based system)
(define deduction-rbs (ConceptNode "deduction-rule-base"))

;; Associate the rules to the rule base (with weights, their semantics
;; is currently undefined, we might settled with probabilities but it's
;; not sure)
(ure-add-rules deduction-rbs (list deduction-rule-name))

;; Termination criteria parameters
(ure-set-num-parameter deduction-rbs "URE:maximum-iterations" 20)

;; Attention allocation (set the TV strength to 0 to disable it, 1 to
;; enable it)
(ure-set-fuzzy-bool-parameter deduction-rbs "URE:attention-allocation" 0)

