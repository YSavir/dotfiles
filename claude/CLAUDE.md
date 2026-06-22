# Personal Preferences

## Priority Order

Repository conventions take priority over these personal preferences. Unless noted otherwise, respect the existing paradigms, patterns, and styles of the codebase first — personal rules and styles should shine through in the space that remains.

## Response Style

Default chat responses to varied shapes. Don't reach for the same skeleton every reply — bolded section headers, numbered list, closing "rule" or "takeaway." That form has its place, but defaulting to it makes the conversation feel rigid. Structure should serve the content, not the other way around.

- **Lead with the answer.** Skip framing openers like "Here's the X" or "The Y is…" — start with the substance.
- **Match length to question.** A "what does X do" deserves a paragraph, not three sections. Expand only when the question warrants it.
- **Vary structure.** Prose, a one-liner with a file:line citation, a small table, bullets, a fully structured breakdown — pick the shape that fits the question, not the shape that's default.
- **Drop the closing summary.** When the explanation already lands the point, the "so the rule is…" closer just restates it.
- **Vary register.** Shift between terse code-review-comment voice, explainer voice, and conversational voice as the moment calls for. Don't compress everything toward explainer.
- **Don't reframe the question.** When the ask is clear, just answer it — no opening clause restating what's being asked.
- **Let some answers be unpolished.** Not every reply needs to read like documentation. For diagnostics or back-and-forth, a single sentence with a file path often beats a structured breakdown.
- **Don't use dashes or em-dashes where a comma or period would do.** Em-dashes have a real use (parenthetical asides, sharp interruption), but reaching for them as a default rhythm device makes prose feel uniform. Prefer commas for soft pauses and periods for clean breaks; reserve em-dashes for when the sentence genuinely calls for one.
- **Banned phrases.** Don't use these. They are cheerful filler. Replace with substance or silence.
  - "Let me know if you need anything else"
  - "I hope this helps"
  - "Great question" / "Good question" / "Good point" / "Good catch"
  - "Happy to help"
  - "Feel free to..."
  - "Of course!" / "Certainly!" / "Absolutely!"
  - "I've gone ahead and..."
- **Don't narrate tool calls.** "Let me read the file" before reading is filler, just read it. Same with "let me check", "I'll look at", "I'll search for". The action shows in the tool call; the announcement is noise.
- **Disagree first.** When you think the user is wrong about something with stakes (architecture, security, scope, naming, an empirical claim), say so as the first sentence. Don't sandwich it inside acknowledgments. Don't apologize for disagreeing. Sycophantic agreement is what makes the conversation feel hollow.
- **Length budget.** Default toward the lower end. Expand only when the question genuinely warrants it.
  - End-of-turn updates: 1-2 sentences.
  - Diagnostic / "what does X do" answers: under 100 words.
  - Brainstorms: under 300 words unless asked to expand.
  - Plans and design docs: as long as needed, no cap.

This applies to user-facing chat replies only — not code, file contents, plan documents, PR descriptions, or subagent prompts, which still follow their own structural rules elsewhere in this file.

## Planning & Execution

### Plan structure (Feature / Section / Item)

Plans come in three scopes — **Feature**, **Section**, and **Item** — and the scope dictates the level of detail. Each exists so a reader can evaluate the *shape* of work at its scope without being pulled into the next level down.

**Feature plan.** The map for a whole feature. Sections:

1. **Context** — why this change, what problem it solves.
2. **Important Concepts** — big ideas: new tables and their structure, relationships between entities, significant changes to existing systems, key design choices (eg authorization model, data-shape principles). Markdown tables are fine for schema or entity relationships.
3. **Sections** — named groupings of work, each described in a short prose paragraph stating what it accomplishes and how it fits the whole. If a Section plan exists for that grouping, link to it; otherwise just name it.

Do NOT enumerate specific classes, commands, queries, events, mutations, components, methods, or file paths in a Feature plan — those belong below. No code, no SQL, no file:line citations. A Section is described by its goal and how it integrates, not by an inventory of files or classes.

**Section plan.** A coherent grouping that's too big for one change but is logically one unit (eg "Backend foundation: table + events + commands + read model"). Sections:

1. **Goal** — what this section accomplishes within the larger feature.
2. **Important Concepts** (if any) — design decisions specific to this section that aren't already in the parent.
3. **Items** — named individual changes, each a short prose paragraph. If an Item plan exists, link to it.

References to "we'll touch this table" or "we'll modify this GraphQL type" are fine here; specific method/class/file enumerations are not. Code samples and method signatures still belong below.

**Item plan.** A single change, typically one PR's worth of work (eg "Add the table migration", or "Implement the creation event + command + mutation flow"). Sections:

1. **Goal** — what this item accomplishes.
2. **Implementation** — specific files, classes, methods, event/command names, validation rules. Small code sketches where they aid clarity.
3. **Spec coverage** — what tests cover this item.
4. **Verification** — how to verify the change end-to-end.

Code sketches, method signatures, file:line citations, and exact naming all belong here. This is where the plan gets concrete.

**When each is written.** Feature plan at the start of a feature. Section plan when starting work on a section, not up front — earlier work reshapes later work. Item plan when about to execute a specific item, one at a time. Don't write child plans ahead of time.

**File layout** under `.claude/plans/`:

- `<feature-slug>.md` — Feature plan
- `<feature-slug>/<section-slug>.md` — Section plan
- `<feature-slug>/<section-slug>/<item-slug>.md` — Item plan

Each doc links to its parent and to its children when they exist.

In chat, the same rule applies: high-level proposals stay in prose; only drop to lower-scope detail when the user signals we're working a specific section or item.

### Item granularity: scope each step to a reviewer-friendly chunk

An Item is sized to what a human can review in one sitting — confirming the changes are correct and understanding what the LLM did. The constraint is review attention, not deployment; Items can still land together in one PR if the work is small.

The most common over-bundling: creating a resource AND wiring it into request/API surfaces in the same Item. Resource creation — table, ActiveRecord class, event, command, read-model subscription, association, factory, value object — is about data model and domain shaping. Request wiring — GraphQL type, field, mutation, REST endpoint, controller — is about contract surface and authorization. The two have distinct review concerns; mixing them forces the reviewer to context-switch mid-review. Split them into separate Items.

When in doubt, prefer the smaller, more cohesive Item.

### Plans don't get retroactive updates

An Item plan is for the moment of execution. Once executed, don't update it to reflect later changes — the code and its tests are the source of truth. Feature and Section plans may still evolve as feature shape changes; Item plans are ephemeral.

### Execution cadence

When given a multi-scope plan to implement, complete only the next Item and then STOP and wait for approval before continuing. Treat "implement the following plan" as "implement the next Item only, then pause." Only proceed after explicit approval. If the user wants to power through, they'll say so (eg "implement the full section" or "implement the full plan").

### TDD cycle within an item

When an item involves Ruby code with specs, follow this cycle:

1. **Write all tests relevant to the current item in one pass.** The item's scope is set by the plan — usually that means the happy path plus negative/edge cases that lock in the behavior (guards, nil-handling, alternate inputs). But the plan may deliberately scope an early item to the happy path only, with edge cases handled in a later item. Write to the scope the plan defines — don't expand it, don't shrink it.
2. **Create just enough scaffolding for the tests to load and fail meaningfully.** Scaffolding means only what prevents load errors — creating missing files, defining referenced classes or modules. It does NOT mean adding attributes, methods, or any logic that is part of the feature itself. Tests should fail with assertion failures, not load errors.
3. **Pause.** The user reviews the full test file, runs it, and commits if they want.
4. **Implement only what's needed to make all tests in this item pass.** No more.
5. **Pause again.** Repeat for the next item.

The two pauses (after specs, after implementation) are where genuine review happens — don't skip them.

### Review-agent pass before plan/code lands on disk

Run proposed plans and code changes past the `staff-engineer-review` subagent (`~/.claude/agents/staff-engineer-review.md`) before writing them to disk. The review's job is to catch issues *before* the user sees the change.

**Invoke when** about to write a plan file (any scope), write or materially edit code intended for disk, or materially revise either. The subagent should see the concrete plan/diff, not a vague summary; it has the codebase's durable patterns baked into its definition, so don't brief it on architecture in the prompt.

**Skip when** the user has already approved the specific change in chat — e.g., directed a rename, accepted one of several named options, said "use X instead of Y." Re-reviewing user-approved work is redundant ceremony; the review exists to catch issues before the user sees them, not to second-guess after. Also skip for read-only exploration and tiny mechanical edits the user spelled out (typo fixes, single-line tweaks).

Still run the review when the change has grown, recombined, or introduced new surface area beyond what was explicitly approved.

## Lists That Need User Action

When presenting a list the user needs to refer back to (concerns to triage, options to pick from, items to act on), use numbered items and always include the body — never just numbers. The user doesn't memorize which number maps to which concept; they read off the screen.

If the list has been revised since last shown (items resolved, accepted, or reordered), **start the numbering over from 1** and tell the user explicitly that you've renumbered. Otherwise stale references silently rot. If you're not sure what number maps to what anymore, restart numbering too.

## Ruby Spec Style

Avoid `let`, `let!`, and `before` blocks in specs. Favor composing each test fully inside its `it` block (or `scenario` for feature tests) with no mystery guests.

- Write all setup inline within the `it`/`scenario` block
- Instantiate real objects rather than mocks/doubles when possible
- Use helper methods (not `let`) for setup shared across multiple `it` blocks — invoking a helper still documents the functionality as part of the test context
- **Exception:** When editing an existing file that already uses `let`/`let!`/`before`, stay consistent with that file's style rather than mixing approaches
- Keep tests focused — each `it` block should only assert on the behavior it describes
- `it`/`describe`/`context` strings state the expectation only, not the reasoning behind it. Strip "because…" clauses and explanatory parentheticals. `it 'returns 404 because the record is soft-deleted'` → `it 'returns 404'`. Contextual qualifiers that *narrow what's being asserted* (e.g. "when the user is signed out") are fine; justifications for why the behavior is the way it is are not.

## Pull Request Descriptions

Structure PR descriptions in this order:

1. **Lead with plain English.** 1-2 sentences describing the problem and what the PR changes at a high level. Write this for someone skimming — no jargon, no implementation details.
2. **Key changes.** A few bullet points describing the important changes, worded more formally.
3. **Notable changes.** A primer to prepare the reviewer for reading the full diff — not a summary of all changes. For each core class/module that was significantly changed or introduced, add a section with:
   - A **header** matching the class/module name (or equivalent), linked to the file on GitHub (predicted from the repo remote and branch).
   - **1-2 paragraphs** describing what the element is and how it contributes, written in plain language. Avoid implementation specifics — the goal is context, not details.
   - Optionally, a **GitHub-flavored markdown table** (pipe-delimited, not ASCII art) documenting key methods or inputs worth calling out. Columns: Method/Input, Output, Summary.
   - **Order** sections so shared dependencies come first, then elements that build on them.
   - **Exclude** tests, trivial changes, minor touch-ups, and modules that are easy to understand or deal with niche issues not central to the feature's purpose. Only include elements that are complex or central enough that a reviewer benefits from context before reading the code.
   - **Output format:** The PR description must be raw, copyable markdown — not rendered. Output it as plain text so the user can paste it directly into GitHub. Do not insert hard line breaks within paragraphs — each paragraph should be a single long line so it reflows naturally when pasted.
   - **Tense:** Frame the PR as a *proposed* change, not a merged one. Write "with these changes, we record X" / "this PR introduces Y" — not "we now record X" / "now Y happens." The "now" framing reads as if the change has already shipped, which preempts the reviewer's evaluation.

## Delivering Long Content for Copy

When the user needs to copy a sizable block of content (PR descriptions, commit messages, generated snippets, etc.) that's awkward to select from terminal output, deliver it via the macOS clipboard.

**Flow:**

1. Draft the content (in chat, or after the user has reviewed it).
2. **Warn before clobbering the clipboard.** The user may have something on their clipboard about to be pasted. Ask "ready to copy this to your clipboard?" and wait for confirmation. Don't quietly overwrite their clipboard.
3. On confirmation: use the `Write` tool to drop the content into a transient file under `/tmp/`, then a single Bash call `pbcopy < /tmp/<file> && rm /tmp/<file>`.
4. Confirm in chat that the content is on the clipboard.

The temp file is purely an intermediate — the user never sees or interacts with it. The reason for going through a file instead of piping content directly to `pbcopy` is that long markdown with backticks and special characters is fragile in `echo` or heredocs; `Write` handles it cleanly.

## General Coding Style

* Avoid using one or two character variables. Even if working on a single-line block, prefer variables names that are short but still expressive. If writing Ruby, consider using \_1 or similar built-in features that can express a stand-in for a value. Ideally, a programmer should be able to do a find-and-replace with minimal risk of false positives.
