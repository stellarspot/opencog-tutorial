(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)
)

; Ghost Rules
(ghost-parse "u: (my name be _*) $name='_0 Hi $name")
(ghost-parse "u: (what be me name) Your name is $name")

(ghost-parse "u: (I like _* and _*) $item1='_0 I like $item1 too")

; Test Ghost
(test-ghost "My name is John.")
(test-ghost "What is my name?")
(test-ghost "I like apples and bananas.")