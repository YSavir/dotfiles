# Personal Preferences

## Priority Order

Repository conventions take priority over these personal preferences. Unless noted otherwise, respect the existing paradigms, patterns, and styles of the codebase first — personal rules and styles should shine through in the space that remains.

## Multi-Step Plan Execution

When given a multi-step plan to implement, complete only the first step and then STOP and wait for approval before continuing. Treat "implement the following plan" as "implement Step 1 only, then pause." Only proceed to the next step after explicit approval. If all steps at once are wanted, the user will say so (e.g., "implement the full plan").

## Ruby Spec Style

Avoid `let`, `let!`, and `before` blocks in specs. Favor composing each test fully inside its `it` block (or `scenario` for feature tests) with no mystery guests.

- Write all setup inline within the `it`/`scenario` block
- Instantiate real objects rather than mocks/doubles when possible
- Use helper methods (not `let`) for setup shared across multiple `it` blocks — invoking a helper still documents the functionality as part of the test context
- **Exception:** When editing an existing file that already uses `let`/`let!`/`before`, stay consistent with that file's style rather than mixing approaches

## Test-Driven Development Workflow

When executing a plan that involves Ruby code with specs, follow a strict TDD cycle:

1. **Write the spec first.** Before writing any feature code, write the test.
2. **Create just enough scaffolding for the test to fail meaningfully.** Define the classes/files the spec references so it can load and run — but don't implement the logic. The test should fail with an assertion failure, not a load error.
3. **Pause.** Let the user review, run the test, and commit if they want.
4. **Implement only what's needed to make that one test pass.** No more.
5. **Pause again.** Repeat for the next test.

Do not move to the next test until the user signals to proceed.

## General Coding Style

* Avoid using one or two character variables. Even if working on a single-line block, prefer variables names that are short but still expressive. If writing Ruby, consider using \_1 or similar built-in features that can express a stand-in for a value. Ideally, a programmer should be able to do a find-and-replace with minimal risk of false positives.
