# Prose rules

Every report, plan, handoff, PR body, PR reply, commit message, and message to the user follows these rules. Read them before writing, and reread the result once against them before returning.

## Say the concrete thing

- State what happened, what the code does, or what the reader should do. If a sentence cannot be restated as a fact, an instruction, or a number, cut it.
- Name the actor. "The loader parses the file", not "the file is parsed". Passive voice only when the actor is unknown or does not matter.
- Cut adverbs and intensifiers. "Runs quickly" becomes the measurement. "Significantly improves" becomes the delta.
- Use the plain word. "Use", not "utilize" or "leverage". "Help", not "facilitate". "Many", not "numerous". "If", not "in the event that". "To", not "in order to".
- No abstract metaphor nouns: substrate, wedge, vector, surface (as in "API surface"), primitive (as a noun), scaffolding, paradigm, harness (as a metaphor), nexus, bedrock. Pick the concrete word each stands for.
- No significance inflation: pivotal, crucial, testament, landscape, tapestry, showcase, underscore, delve, robust, seamless, elegant.
- No vague attribution ("experts believe", "it is widely known"). Name the source or delete.

## Sentences

- One idea per sentence. If the reader would backtrack, split it.
- No em dashes, no en dashes, no hyphens used as dashes. End the sentence or use a comma.
- Colons only before a list or an example, never as a mid-sentence connector. Never use semicolons.
- No antithesis constructions ("it's not X, it's Y"). State the point.
- No forced groups of three. Use the number of items there are.
- No punchy fragments for effect ("Not a bug. A design choice.").
- Straight quotes. Sentence case headings. No decorative emoji in headings or bullets. The review format's category and severity icons are labels, so they stay.

## Structure

- No inline-header lists where a bold label restates the line ("**Performance:** performance improved"). A bold lead-in that names the item and then adds new detail is fine.
- Bold sparingly, not on every proper noun or acronym.
- Headings and numbered lists only when they help the reader navigate.
- State each fact once. Reference a commit, diff, plan, or comment by SHA, path, or URL instead of restating it.

## Voice

- Have an opinion where the reader needs one. When two options exist, recommend one and say why, instead of listing pros and cons evenly.
- Be specific about uncertainty. Say what you verified, how you verified it, and what you did not check.
- No chatbot phrases ("I hope this helps", "Let me know if", "Certainly", "Great question"). No sycophancy. No closing summary that repeats the body.
- No hedging stacks ("could potentially possibly"). One hedge at most, and only when it changes what the reader does.
- No generic conclusions ("the future looks bright"). End on the last fact or the next action.
