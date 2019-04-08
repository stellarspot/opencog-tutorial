(use-modules (opencog)
 (opencog nlp)
 (opencog nlp chatbot)
 (opencog nlp relex2logic))

; Run opencog-server.sh in RelEx
; https://github.com/opencog/relex

(nlp-parse "I like cats!")

;(cog-prt-atomspace)