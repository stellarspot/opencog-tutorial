(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp chatbot)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)
 (srfi srfi-1))

(nlp-parse "Dogs can bark.")
(nlp-parse "Tobby is a dog.")

; Load rule-base for the trail of inference
(load-trail-3)
(do_pln)

(cog-prt-atomspace)

;; Utility for testing as sureal part is broken
;(define (get-atoms-for-sureal trail)
; (define pln-outputs (cog-value->list
;                      (cog-value trail (Predicate "inference-results"))))
; (if (null? pln-outputs) '() (cog-outgoing-set (filter-for-sureal pln-outputs))))
;
;
;(display
; (get-atoms-for-sureal rb-trail-3))