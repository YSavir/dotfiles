---
name: wrap-up
description: Run a wrap-up checklist on the current feature branch before considering work complete. Use when the user explicitly says "wrap up", "wrap-up", "/wrap-up", or similar. This skill is NOT applied automatically — only when explicitly invoked.
---

# Task Wrap-Up

Run each step in order. Fix issues as you find them.

**Reporting principle (applies to every step):** Surface only findings — things that need fixing, attention, or a decision. Don't enumerate what you checked and ruled out, don't narrate methodology, don't write paragraphs confirming non-issues. If a step finds nothing, one line is enough or omit it from the summary. The user's time is reserved for what matters.

## Step 1: Identify the branch diff and recent context

**Determine the base branch (`<base>`)** the current branch was forked from. Every subsequent step's diff and linter commands use it.

Use the most-recent-merge-base heuristic: among all other local branches, pick the one whose merge-base with `HEAD` is the most recent commit. That's the actual parent — for a trunk-based feature branch it resolves to `main`/`master`/`release`; for a stacked branch (e.g. `feature-1-1` branched off `feature-1`) it resolves to the intermediate parent, not the trunk.

```bash
current=$(git rev-parse --abbrev-ref HEAD)
base=$(
  git for-each-ref --format='%(refname:short)' refs/heads/ \
  | grep -v "^${current}$" \
  | while read -r branch; do
      merge_base=$(git merge-base HEAD "$branch" 2>/dev/null) || continue
      timestamp=$(git log -1 --format=%ct "$merge_base" 2>/dev/null) || continue
      echo "$timestamp $branch"
    done \
  | sort -rn \
  | head -1 \
  | awk '{print $2}'
)
echo "Base: $base"
```

If `$base` comes back empty (only one local branch, orphan branch, etc.), stop and ask the user which branch to compare against — don't guess.

Then load the branch's diff and recent history against `<base>`:

```bash
git diff <base>...HEAD --name-only
git diff <base>...HEAD
git log --oneline -20
git rev-parse --abbrev-ref HEAD
```

Every subsequent step in this skill references `<base>` — substitute the resolved branch name.

Read the full diff. The `git log` catches recent main-branch work that's load-bearing on what this branch touches — commits like "stop flagging X drift as a plan change" signal that attribute X is under active stability management, so any new source of drift introduced by this branch needs to be checked against that gate.

**Linear ticket:** If the branch name contains a ticket identifier (e.g. `yaniv/abc-1234-...` → `ABC-1234`), fetch it via `mcp__claude_ai_Linear__get_issue` and read the description, acceptance criteria, and any linked docs. Hold this alongside the diff as context for the remaining steps. If no ticket ID is derivable from the branch, skip silently.

## Step 2: Ticket requirements

If a Linear ticket was fetched in Step 1, enumerate its stated requirements — acceptance criteria, description bullets, explicit asks in comments — and check each against the branch's diff. List any that are:
- **Not addressed** — the branch didn't touch this at all
- **Partially addressed** — some cases handled, others missing
- **Deferred** — intentionally skipped, but worth surfacing so the user confirms

Report each unmet requirement with the ticket text and what's missing. If every requirement is covered, one line is enough. Skip this step entirely if no ticket was found.

## Step 3: Loose ends

Scan for what the branch left unfinished:
- TODOs/FIXMEs introduced by this branch
- Events published but not subscribed; reactors missing from event_bus wiring
- GraphQL fields/mutations added on one side only (backend or frontend)
- New code with zero callers
- Missing specs for new or changed behavior

## Step 4: Dead code

Look for what the branch's renames/deletions/refactors left behind:
- Methods, classes, modules with no remaining callers
- Unused imports, types, enums, constants, factory traits
- Specs testing removed behavior

Remove confirmed dead code. Flag uncertainty (dynamic dispatch, external callers) rather than delete.

## Step 5: Logical and operational consistency

Review changes holistically for contradictions:
- Producer/consumer shape mismatches (events, APIs, GraphQL, props)
- Code still assuming pre-branch behavior (e.g. a reactor expecting a removed field)
- Naming drift across layers
- Edge cases the new code doesn't handle that the old code did

## Step 6: Unaddressed side-effects

For each function, query, event, type, or column whose behavior or shape changed, trace impact until you reach a leaf — a persisted column, user-visible UI field, analytics event, email, or job effect. **Depth-1 grep is not sufficient. Misses live at depth 3+.**

### Required moves

**Anchor every change to a leaf.** For each changed API, name the column written, the GraphQL/UI field shown, the email sent, or the analytics event fired. "Exposed via GraphQL" is not a leaf — keep going to the React component or stored field. If you can't name a leaf, you haven't traced far enough.

**Open files surfaced by grep, don't just count them.** When grep reveals a gatekeeper-sounding neighbor (`*_skippable.rb`, `change_detection`, `immaterial_*`, `validation_*`, `cache_*`, `*_invalidation`), read it. These files often decide whether the cascade fires downstream.

**Treat persisted derivatives as the primary concern.** If a changed function feeds a stored column (the `read_attribute || compute` fallback pattern is the classic case, but any cached/persisted computation qualifies):
- Read the **write path**: when does the column get recomputed and re-persisted?
- Read the **read path**: what consumes the column?
- Read the **gate**: is there change-detection logic that fires when the column drifts? Recent main-branch commits touching this attribute (from Step 1's `git log`) usually signal an active stability concern.
- Lead with this finding in the report — don't bury it inside a cohort or edge-case discussion.

**Enumerate every reachable parameter dimension before claiming "no change."** Before concluding a refactor is a no-op, list every value of every parameter the function branches on — every enum member, nil, out-of-range values — and confirm none reachable from production callers produce a different result. A partial "no change" conclusion is the known trap: it suppresses further investigation for the dimensions you didn't check. The failure mode is silent and confirmation-biased.

**Delegate non-trivial traces to an Explore subagent.** Default to this whenever the cascade is deeper than 2 hops, when a persisted derivative or stored column is involved, or when grep returns more than a handful of files to investigate. Prompt: "trace all transitive consumers of X, including persisted derivatives, write paths, read paths, and any gate/change-detection logic; for each path, name the leaf and the parameter dimension that triggers it."

### Reporting format

For each real or potential side-effect:
- **Changed API** — what changed
- **Path** — the chain through the codebase
- **Leaf** — column / UI field / event / email / job
- **Trigger** — parameter dimension that produces the effect (if conditional)

Frame as a primary finding. If a single trace found nothing after the moves above, one line is enough.

## Step 7: Codebase convention adherence

Scan the branch's new code for blocks that read as out of place — code written as if the author didn't know the framework, the codebase, or the project's architecture. Common LLM output has a smell: it solves the problem, but through a route no one working in the codebase would have taken.

Rely on judgment, not exhaustive comparison. You do not need to open every neighboring file, map every module, or verify every convention. The question is whether the code fits the shape of the codebase it lives in, or whether it reinvents, sidesteps, or ignores what's already there. The flavor: a manual validation block in a Rails model where `ActiveModel::Validations` would apply, logic that bypasses the architectural layer (CQRS, domain events, whatever the codebase leans on) it should be routed through, a wrapper class that adds ceremony without behavior, or code that reads as generic LLM output rather than matching the register of the surrounding project.

When something feels off, cite `file:line`, describe what looks wrong, and, if you're confident, note the convention it should use instead. If you're unsure whether the codebase provides an alternative, say so and stop — do not spend the effort to definitively map every neighbor.

Don't silently rewrite. Flag for the user to decide.

If nothing looks off, one line is enough.

## Step 8: Comments

Delegate to the `comment-hygiene` subagent. It applies the "Code Comments" rules from `~/.claude/CLAUDE.md` and edits directly, so this step both cleans up existing violations and adds missing comments in one pass.

**Delegation prompt:**

> Audit comments introduced by this branch against `<base>`.
>
> - Run `git diff <base>...HEAD --name-only` to find files this branch touched, and `git diff <base>...HEAD -- <file>` to see what changed within each.
> - Scope: comments this branch introduced or modified, plus code hunks in the diff that need a comment per the CLAUDE.md rules.
> - Do not touch comments outside that scope, even if they violate the rules — those are out of scope for this branch's wrap-up.
>
> Return your standard two-section report.

The agent's "Changes applied" section doubles as the change log for this step; its "Cases for you to decide" section surfaces genuine ambiguities where the rules pull in conflicting directions. Pass both through to the user verbatim — don't summarize or re-editorialize the findings.

## Step 9: Linters

Run linters only on files changed by this branch. Fix all failures.

**Ruby (RuboCop):**
```bash
git diff <base>...HEAD --name-only -- '*.rb' | xargs bundle exec rubocop
```

If auto-fixable:
```bash
git diff <base>...HEAD --name-only -- '*.rb' | xargs bundle exec rubocop -a
```

**JavaScript/TypeScript (ESLint):**
```bash
git diff <base>...HEAD --name-only -- '*.ts' '*.tsx' '*.js' '*.jsx' | xargs yarn eslint --fix
```

**TypeScript type checking:**
```bash
yarn tsc --noEmit
```

## Final summary

One concise summary. List only findings — what was fixed, what's flagged for user attention, any remaining linter failures. Steps that found nothing can be omitted entirely. The user can prompt for more detail on anything listed.
