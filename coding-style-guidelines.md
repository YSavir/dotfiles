# Coding Style Guidelines

---

## 1. Philosophy & Orientation

**1.1** Organize code around objects and their relationships, not functions and transformations. Classes are the natural unit of abstraction. Code should be easy to follow from entry point to outcome without a debugger. Prioritize readability and traceability over architectural purity.

**1.2** Keep inheritance shallow — one level is the norm, two is rare. Avoid deep or multi-level class hierarchies entirely.

**1.3** Satisfy the instinct to share behavior through composition (relationships, delegation), not inheritance or mixins.

**1.4** Use mixins and modules sparingly. Behavior belongs in the class that owns it. Do not distribute it across mixed-in modules.

**1.5** Let a class do several related things rather than splitting everything into thin layers. A class can hold validations, scopes, callbacks, and business methods when they are coherent. Prefer this over a proliferation of single-purpose objects. The test is readability and traceability, not theoretical purity.

**1.6** Accept mutation. Update objects in place. Do not return new copies to preserve immutability.

**1.7** Default to straightforward methods and loops. Reach for metaprogramming, higher-order functions, or clever abstractions only when they provide obvious, concrete benefit.

**1.8** Build custom solutions when off-the-shelf libraries don't fit the domain model. Do not force a domain into a library's mental model. Delegate to third-party tools only for true commodities.

---

## 2. Deliberate Omissions

These practices are intentionally absent. Do not introduce them.

**2.1** **No type annotations.** No TypeScript, no runtime type checking, no type guards in business logic. Communicate types through naming alone.

**2.2** **No inline documentation.** Names and structure carry the meaning. Omit JSDoc, RDoc, docstrings, and explanatory comments for clear logic.

**2.3** **No defensive boundary validation.** Validate at the model level, not at every layer boundary. Let controllers and service objects trust that data has the right shape.

**2.4** **No functional programming patterns.** No `compose`, `curry`, `memoize`, or pipeline abstractions. Use utility libraries for basic collection operations, not as a functional programming toolkit.

**2.5** **No `handle` / `get` / `on` method name prefixes.**

**2.6** **No optional chaining** (JS). Assume property access is valid; handle null cases with explicit checks elsewhere.

**2.7** **No obligation to eliminate type-based conditionals through polymorphism.** A `case`/`if` that branches on a type or string value is fine.

**2.8** **No abstract interfaces or protocols.** Rely on duck typing. If something responds to the expected methods, it's usable.

**2.9** **No scoped styles** (CSS). Keep all styles global. Isolate components through class naming conventions, not technical scoping.

**2.10** **No application-level caching.** Rely on database queries to avoid cache invalidation complexity. Use instance-level memoization only.

**2.11** **No authorization libraries.** Build authorization logic directly when domain rules don't map cleanly to a library's model. Do not bend the domain to fit the library.

**2.12** **No structured logging in application code.** Use stdout in development, a monitoring service in production.

---

## 3. Naming

**3.1** Name methods for the action, not the event that triggered them.
- Good: `removeFromScreen`, `assignSlug`, `sanitizeBody`, `loadCurrentUser`
- Avoid: `handleClick`, `onClick`, `onSubmit`, `getData`, `getUser`

**3.2** Name service and operator classes as verb + noun so the role is immediately obvious without opening the file.
- Examples: `SampleDataGenerator`, `PaymentCharger`, `UserAdder`

**3.3** Make boolean-signaling names unambiguous. Use the `?` suffix on predicate methods in Ruby. In JavaScript, use `is`, `has`, `show`, or `allow` prefixes when the name alone would be unclear. Never use a `flag_` prefix.

**3.4** In JavaScript, prefix private and internal methods and properties with an underscore. This is the sole convention for marking something internal — do not use private class fields or access modifiers.

---

## 4. Documentation

**4.1** Write comments only in three narrow cases:
1. A non-obvious workaround, constraint, or edge case that would otherwise look like a bug
2. A method intentionally left empty for subclasses to override
3. A temporary or defensive escape hatch, with a self-fix condition noted

**4.2** When borrowing or adapting code from an external source, cite the source with a brief explanation of why it was not used as a dependency.

**4.3** Do not write method-level documentation, parameter descriptions, or explanatory inline comments for clear logic.

---

## 5. Error Handling

**5.1** Communicate errors through state, not exceptions. Operations track their own success or failure and expose the result through state readers. Callers inspect the outcome — they do not rescue.

**5.2** Catch exceptions once, at the outermost execution boundary. Dispatch them to a monitoring service in production; print them to stdout with a backtrace in development. Do not catch exceptions mid-operation and convert them into return values.

**5.3** Raise exceptions only for programmer errors — impossible states that indicate a bug, not a user error or external failure.

**5.4** In JavaScript, store API errors on the resource object and return a falsy value or resolved promise. Do not throw into the calling layer. Let the caller inspect state.

---

## 6. Code Style

**6.1** Put guard clauses at the top, body below. Return immediately from no-op conditions and invalid states. Do not wrap the main logic body in a conditional.

**6.2** Keep nesting shallow. Two levels is common; three is a ceiling. Extract a named helper when conditionals or loops nest deeper.

**6.3** Target 8–20 lines per method. Break longer methods up by extracting named private helpers.

**6.4** When defining a block of related constants, align the assignment operators with padding spaces so the values form a column:
```
STATUS_ACTIVE   = 'active'
STATUS_EXPIRED  = 'expired'
STATUS_PENDING  = 'pending'
```

**6.5** Use explicit `return` only for early exits (guard clauses, failure paths) and boolean sentinels where the intent would otherwise be unclear. Return the final computed value of a method implicitly.

**6.6** Check absence at the appropriate level of specificity. Use an explicit nil check when only `nil` is invalid. Use a combined nil-and-empty check when blank values are also invalid. Do not substitute one for the other.

**6.7** Follow every guard clause or early-exit block with a blank line. Separate distinct logical steps within a method with blank lines as well. Never place blank lines inside a conditional block. Treat the method like paragraphs — related lines are dense, transitions are spacious.

**6.8** (Ruby) Use `unless` only when the negated condition governs a multi-line early-exit block. For all other negated conditions — inline guards, standard conditional branches — use `if !` instead.

---

## 7. Data Flow & Module Communication

**7.1** Pass dependencies inward — into a module at construction or as method arguments. Do not reach outward to find what is needed.

**7.2** Choose the calling convention based on whether the outcome matters to the caller:
- **Fire-and-forget:** call the operation and do not inspect the result. Use this when the side effect is the entire purpose and failure is impossible or acceptable to ignore.
- **Result inspection:** check state readers or the return value after the operation runs, and branch on the outcome. Use this when the next step depends on what happened.

**7.3** Return the primary object an operation worked on, not a status boolean. Express success or failure through inspectable state, separately from the return value.

**7.4** Keep shared state in a single owning object. Pass that object to others or let them read from it on demand. Do not maintain duplicate copies of state across modules.

**7.5** Structure mutation handlers consistently: validate or authorize at the top, perform the action, then branch on success or failure. Keep the success path and failure path separate — never interleave them.

**7.6** (JavaScript) Send notifications and state change announcements upward through events. Emit a named event when something meaningful happens; let interested parties register listeners separately. Events are fire-and-forget and carry no return value. Use per-instance event emitters, not a global bus.

---

## 8. Side Effect Hooks

**8.1** Reserve lifecycle hooks (pre-save, post-create, etc.) for idempotent data normalization only — setting default values, generating slugs or identifiers, sanitizing content. Put no business logic in them.

**8.2** Put business logic, multi-step workflows, and orchestration across multiple objects in dedicated service objects, never in lifecycle hooks.

**8.3** Write lifecycle hooks that set defaults or generate values as one-liner guards: set the value only if it is not already set, so the hook is safe to run multiple times.

---

## 9. Data Modeling

**9.1** Use a timestamp field for soft deletes, named for the state transition — not a boolean flag and not a generic `deleted_at`. The column name should reflect the domain event (e.g., `archive_time`, `cancellation_time`, `locked_at`). Expose active and archived states via named scopes.

**9.2** Give discrete lifecycle events their own timestamp column, named for the event. Do not use a generic `updated_at` as a substitute when the timing of specific events matters independently.

**9.3** Store external or shareable identifiers as UUIDs in a dedicated column alongside the integer primary key. Do not use UUIDs as primary keys.

**9.4** Use polymorphic associations liberally for extensibility. When multiple models need to relate to the same concept, prefer a polymorphic association over separate join tables or nullable foreign keys.

**9.5** Give join tables that carry business logic — scopes, methods, validations, or attributes beyond the two foreign keys — full model status. Keep pure connective records with no logic minimal.

**9.6** When a cross-cutting concern is present (e.g., external sync, content sharing), group its columns together on the table. Do not scatter concern-related columns among unrelated ones.

**9.7** Denormalize only for two reasons: routing or lookup optimization, or immutable snapshots that capture the state of data at a point in time for historical integrity. Do not denormalize for aggregates or summaries.

**9.8** Avoid unstructured blob column types even where they would be applicable. Prefer structured columns. Use arrays for simple multi-value fields where each element has no identity of its own.

**9.9** Add indexes for: every foreign key, every polymorphic type+id pair (as a composite), and every column or combination of columns involved in a business uniqueness constraint. Do not index simple status or flag columns that are not used for filtering.

**9.10** Write migrations to be small, single-purpose, and reversible. Each migration does one thing. Name migrations to describe the exact change made.

---

## 10. Ruby Specifics

**10.1** Use keyword arguments for any method where argument order would be ambiguous or where there are more than two parameters. Use positional arguments only when the call site is self-evidently clear.

**10.2** Define 3–8 scopes per model using stabby lambda syntax. Use scopes to encapsulate common query conditions rather than repeating query clauses at call sites.

**10.3** Use modules and concerns only for behavior that is genuinely shared across unrelated classes and cannot be expressed through association. A class with unique behavior keeps it to itself.

---

## 11. JavaScript Specifics

**11.1** Default to `.then()` chains for async code. Use `async/await` only when it is genuinely necessary for control flow.

**11.2** Do not use optional chaining (`?.`). Handle null/undefined safety through explicit existence checks, guard clauses, or structural guarantees.

**11.3** Export utility singletons as instances, not classes. Instantiate a utility class once and export the instance. Consumers import the instance directly — they do not instantiate it themselves.

**11.4** Use a standard utility library for collection operations (`sort`, `clone`, `isEmpty`, `defaults`, `includes`, etc.) rather than custom implementations or native equivalents.

**11.5** Declare module behavior statically where possible. Express what a module loads on initialization, its initial state shape, and its post-load behavior as static configuration, not as imperative setup buried in a constructor.

---

## 12. CSS/SCSS

**12.1** Keep all styles global. Achieve component isolation through class naming conventions — typically a project-specific prefix on custom components — not CSS scoping mechanisms.

**12.2** Generate utility classes for spacing and similar repeating patterns programmatically using loops over a size or value map. Do not write them one by one.

**12.3** Nest state variants (`active`, `hover`, `disabled`, etc.) within the component's rule block. Do not define them as separate top-level rules.

---

## 13. Development & Commit Practices

**13.1** Write commit messages in lowercase, imperative, single-line form. Use no conventional commit prefixes (`feat:`, `fix:`, `chore:`) and no ticket references. Describe what the commit does in plain language.
- Examples: `add session article images upload and show`, `extract http statuses to owned library`, `remove debuggers and console logs`

**13.2** Make each commit atomic and single-purpose. Address one clear feature, fix, or cleanup per commit. Do not bundle unrelated changes.

**13.3** Build features across sequential commits — a minimal version first, then extensions, then refinements. Do not hold a feature until it is "complete." Commit at each meaningful milestone.

**13.4** Commit cleanup separately. Removing old code, deleting dead branches, and cleaning up debug output each get their own commit. Do not fold cleanup into feature work.

**13.5** Do not commit debugging artifacts. Remove debugger statements and console logging before committing.

**13.6** Build features outside-in: start from the user-facing interaction layer and work toward the data layer. Establish the visible, interactive outcome first — even as an empty shell — before filling in the supporting infrastructure. Let tests accompany the code they cover throughout; do not defer them to the end.

---

## 14. Testing

**14.1** Organize tests by feature group → condition → assertion. Use `describe` to name the feature or method, `context` to describe the condition (with `when ...`), and `it` to make the assertion. Rarely nest beyond three levels.

**14.2** Write `it` descriptions as extremely short, present-tense statements — typically 3–7 words. State a fact about the outcome. Use no "should" language. Do not repeat the surrounding `describe` or `context` — only add the final claim.
- Examples: `'is null'`, `'returns false'`, `'is the session details template'`

**14.3** Create test data inline within each test. Do not use shared setup constructs (`let`, `let!`, `before`). Use `subject` only in model validation tests alongside shoulda-style matchers. Construct everything else on the spot.

**14.4** Construct the subject under test without persistence when the test only needs its attributes or validation behavior. Always persist dependencies and associated records that must exist in the data store. Persist what the test queries for; keep the unit under test lightweight when possible.

**14.5** Write one assertion per test by default. Add multiple assertions only when they verify the same logical outcome — closely related side effects of a single action that cannot be meaningfully separated.

**14.6** In endpoint and handler tests, assert on observable side effects (database changes, external calls made) and HTTP semantics (status codes). Do not inspect response body structure or internal variable state.

**14.7** Apply mocking at the method level, not the class level. Use `allow(object).to receive(:method)` rather than class-level or instance-of stubs. Use `spy` objects to verify that a method was called. Never use `allow_any_instance_of`.

**14.8** Use shared examples to test recurring patterns across similar units rather than duplicating setup. Declare a shared behavior once and verify it via the shared example.

**14.9** Test time-dependent logic with a time-freezing utility. Never write a test that passes only when run at a specific moment.
