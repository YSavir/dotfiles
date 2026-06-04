# Personal Preferences

## Priority Order

Repository conventions take priority over these personal preferences. Unless noted otherwise, respect the existing paradigms, patterns, and styles of the codebase first — personal rules and styles should shine through in the space that remains.

## Planning & Execution

### Plan structure (two-tier)

Plans come in two tiers, and the tier dictates the level of detail.

**High-level plan** — the map for a feature. Two sections:

1. **Important Concepts** — highlights big ideas: new tables and their structure, relationships between entities, significant changes to existing systems or features. Prose is the default; markdown tables are fine for laying out columns, fields, or entity relationships. No code, no schema diagrams — enough picture to make the steps that follow comprehensible.
2. **Steps** — a list of digestible steps. Each step gets a short prose description of what it accomplishes and how it fits the whole. No code samples, method signatures, SQL, or file:line citations.

The reader evaluates the *shape* of the work without getting pulled into implementation.

**Low-level plan** — written when we're about to execute one specific step. Scope is narrow enough that implementation specifics (exact files, method names, small code sketches, event/command names) don't drown out the design. Write these one at a time, not up front — earlier steps often reshape later ones.

File layout under `.claude/plans/`: parent as `<feature-slug>.md`, children as `<feature-slug>-step-<n>-<slug>.md`. Parent links children; children link back.

In chat, the same rule applies: high-level proposals stay in prose; only drop to code-level detail when the user signals we're working a specific step.

### Multi-step execution cadence

When given a multi-step plan to implement, complete only the first step and then STOP and wait for approval before continuing. Treat "implement the following plan" as "implement Step 1 only, then pause." Only proceed after explicit approval. If all steps at once are wanted, the user will say so (e.g., "implement the full plan").

### TDD cycle within a step

When a step involves Ruby code with specs, follow this cycle:

1. **Write all tests relevant to the current step in one pass.** A step's scope is set by the plan — usually that means the happy path plus negative/edge cases that lock in the behavior (guards, nil-handling, alternate inputs). But the plan may deliberately scope an early step to the happy path only, with edge cases handled in a later step. Write to the scope the plan defines — don't expand it, don't shrink it.
2. **Create just enough scaffolding for the tests to load and fail meaningfully.** Scaffolding means only what prevents load errors — creating missing files, defining referenced classes or modules. It does NOT mean adding attributes, methods, or any logic that is part of the feature itself. Tests should fail with assertion failures, not load errors.
3. **Pause.** The user reviews the full test file, runs it, and commits if they want.
4. **Implement only what's needed to make all tests in this step pass.** No more.
5. **Pause again.** Repeat for the next step.

The two pauses (after specs, after implementation) are where genuine review happens — don't skip them.

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
