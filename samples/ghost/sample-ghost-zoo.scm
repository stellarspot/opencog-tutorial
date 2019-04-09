(use-modules
 (opencog)
 (opencog nlp)
 (opencog nlp relex2logic)
 (opencog ghost)
 (opencog ghost procedures)
)

; Ghost Rules
(ghost-parse "
concept: ~bird [flamingo swan]
concept: ~reptile [turtle snake]
concept: ~attitude [like hate]

r: ([hello hi]) Welcome to the Zoo! Which animals do you want to see?
  j1: (see ~bird) Birds are so beautiful. Let's go to see them!
  j1: (see ~reptile) Good choice. Let's go to see reptiles!

r: (Do you ~attitude _~bird) $animal=_0 I am a fun of $animal!

r: (Do you ~attitude _~reptile) $animal=_0 I am afraid of $animal!

")

; Test Ghost
(test-ghost "Hello")
(test-ghost "I want to see flamingo")

(test-ghost "Hi")
(test-ghost "I want to see turtle")

(test-ghost "Do you like swans?")
(test-ghost "Do you hate snakes?")
