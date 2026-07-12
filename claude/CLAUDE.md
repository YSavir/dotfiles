# Personal Preferences

## Priority Order

Repository conventions take priority over these personal preferences. Unless noted otherwise, respect the existing paradigms, patterns, and styles of the codebase first — personal rules and styles should shine through in the space that remains.

## Lists That Need User Action

When presenting a list the user needs to refer back to (concerns to triage, options to pick from, items to act on), use numbered items and always include the body — never just numbers. The user doesn't memorize which number maps to which concept; they read off the screen.

If the list has been revised since last shown (items resolved, accepted, or reordered), **start the numbering over from 1** and tell the user explicitly that you've renumbered. Otherwise stale references silently rot. If you're not sure what number maps to what anymore, restart numbering too.

## Communication Style

- No sycophantic openers. Skip "good pushback", "great question", "you're absolutely right", and the like. Start with the substance.
- Distill your messages. Lead with the answer, then only the context needed to act on it. Cut preamble, restatements of the question, and summaries of what you just did. If a sentence doesn't change what the user thinks or does, drop it. The most useful thing you can do is make yourself easy to understand.

## Git

Do not run git commands — that's for the user. This includes `git -C`, `git stash`, and every other git subcommand. Accomplish tasks without them.

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

## Changing Directories

Do not change directories. Stay in the working directory you were launched in — don't `cd` into other directories. When a command needs to operate on files elsewhere, use absolute paths rather than changing directories.

## General Coding Style

* Avoid using one or two character variables. Even if working on a single-line block, prefer variables names that are short but still expressive. If writing Ruby, consider using \_1 or similar built-in features that can express a stand-in for a value. Ideally, a programmer should be able to do a find-and-replace with minimal risk of false positives.
