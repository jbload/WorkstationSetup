## Communication Style
- Be clear, concise, and direct. Use 5 words when 5 will do.
- Default to short answers; let the user ask for more detail.
- Prefer bulleted lists over walls of text where the content is list-like.
- Write like Google developer documentation. Remove all mannered prose. No aphorisms, no flourishes. Simple.

## Intent Interpretation
- Questions ("Should we do X?", "Are there other options for X?", "What would happen if X?") require a response so the user can decide — never take action on a question without an explicit follow-up directive.
- Directives ("Do X", "Add X", "Update X") are requests to act — proceed without asking for confirmation.
- When in doubt, treat the message as a question and respond before acting.

## Collaboration
- When authoring commit messages and PR summaries, DO NOT include references to AI coding assistants (e.g., Codex, Claude Code, Copilot).
- Commit subject lines (the first line) must not use conventional commit prefixes (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`, `ci:`, `style:`, `perf:`, `build:`, `revert:`). Write a plain sentence with normal casing — e.g., "Add request table schema support" not "feat: add request table schema support". The extended body below the subject line is unaffected by this rule.
- PR descriptions must describe the final state of the branch relative to the base branch — not the journey taken to get there. Do not mention intermediate changes that were later amended or superseded within the same branch (e.g., "Replaced Map with Caffeine cache" is wrong if the Map never existed in the base branch). Use `git diff <base-branch>...HEAD` to understand what actually changed relative to the base.
- When you fix code in response to PR feedback, ALWAYS mark that feedback comment as resolved. 
- When instructed by the user not to implement a fix suggested in PR feedback, ALWAYS respond to that feedback with a brief comment explaining why it will not be implemented then mark that feedback comment as resolved.
- When responding to feedback or making a follow-up tweak to a commit you created on the current branch, amend that commit rather than creating a new one. Err on the side of amending — transient commits like "Fixed typo," "Renamed variable," or "Fixed build" should never appear in branch history. Keep the branch history as a clean sequence of logical, meaningful commits that tell the story of what you did and why. Never amend commits that already exist in the base branch.

## Incremental Implementation
The following workflow activates ONLY when the user explicitly requests "incremental implementation" or "logical commits." Do not use this workflow otherwise.

When activated:
1. **Plan first.** Before writing any code, propose a numbered list of commits. Each commit must be a self-contained, testable chunk of functionality — not an architectural layer. Think "what can the user run and verify?" not "what abstraction layer is this?"
   - Wrong: "Add all models" → "Add all DAOs" → "Add all services"
   - Right: "Add column migration and the DAO/service code to populate it" → "Add the dry-run path end-to-end" → "Add the delete path"
2. **Get approval on the plan** before implementing anything. The user may reorder, split, merge, or remove items.
3. **Implement one commit at a time.** After implementing a commit, stop and present the work for review. Do not proceed to the next commit until the user says to commit and move on.
4. **Track progress.** After each commit, display the full list with completion status:
   - ✅ Completed commits
   - 🔨 Current commit (if in progress)
   - ⬚ Remaining commits
5. **Amend, don't stack fixups.** If the user requests tweaks to the current commit's code, amend that commit per the existing Collaboration rules — do not create separate fixup commits.
6. **The plan can evolve.** The user may adjust the remaining plan at any point. Update the list accordingly.

## Coding Style

### Comments
- Write ZERO comments. This is a hard constraint, not a preference, and it applies to code you write from scratch as well as code you edit. It overrides any default instruction to match the surrounding file's comment density — even if every other line in the file or repo is commented, the code you add has no comments.
- Code must be self-documenting. If a block feels like it needs a comment to be understood, that is a signal to extract it into a well-named method or rename a variable — not to explain it in prose.
- Do not write: summaries of what the next lines do, section banners, "why" rationale, Javadoc/docstrings/JSDoc on new types or methods, TODO/FIXME/NOTE markers, commented-out code, or placeholders like `// implementation here`.
- The ONLY comments you may add unprompted are ones a tool or the compiler requires: license/copyright headers, the justification text on `@SuppressWarnings` / `// eslint-disable-next-line` / `# noqa` / `# type: ignore`, and codegen markers.
- When the user explicitly asks for a comment (e.g. "add a comment explaining why we use X instead of Y"), write exactly that one comment, covering exactly what was asked, at the place it was asked for. Do not treat the request as permission to comment anything else in the file, and do not expand it into a broader explanation than requested.
- Comments that already exist in a file are not yours to touch. Never delete or reword them. If you modify code an existing comment describes, update that comment only enough to keep it accurate.
- Before presenting new or modified code, re-read your own diff and delete every comment you added that isn't in the required-by-tooling list above or explicitly requested.

### General
- Do not make drive-by changes to code you are not otherwise modifying. No renaming variables "for clarity," no reformatting untouched lines, no reorganizing imports in files you didn't change. Keep diffs focused on the task at hand.
- All control-flow blocks (`if`, `else`, `else if`, `for`, `while`, `do`, `switch`, `try`, `catch`, `finally`) MUST have a blank line before the opening line and a blank line after the closing line. The only exceptions are:
  - No blank line before the block when its opening line is the first statement in its enclosing method/constructor/lambda body
  - No blank line after the block when its closing line is the last statement in its enclosing method/constructor/lambda body
  - Applies to all languages (Java, TypeScript/JavaScript, Python, etc.)
  - Consecutive `else`/`else if`/`catch`/`finally` clauses are part of the same block — the blank-line rule applies to the outer block as a whole, not between the chained clauses
- Methods within a class are ordered: public methods before private methods. Within each visibility group, order methods by call hierarchy using breadth-first traversal — callers appear before their callees, and all direct callees of a method are listed before any of those callees' own sub-callees. Example: if A calls a, b, c; b calls b1, b2; and c calls c1, c2 — the order is: A, a, b, c, b1, b2, c1, c2. Applies to all languages (Java, TypeScript/JavaScript, Python, etc.). Do not reorder existing methods unless asked explicitly to do so but when creating new methods, their placement should follow these ordering rules.
- **Methods read as named steps.** When you write a new method or substantially rewrite an existing one, the test is not length — it is altitude. Every statement in a method body must sit at the same level of abstraction. A method that orchestrates steps contains only calls to named steps; it does not also compute, filter, map, collect, resolve config, or build objects inline. Push that work down into well-named private methods.
  - The naming test: describe the method out loud in one sentence per step, the way you would explain it to a teammate. Each of those sentences becomes one method call, named after the sentence. If you cannot read the method body top-to-bottom as that description, it is not done.
  - Name extracted methods with a verb phrase describing the action, not a noun phrase naming the value. Prefer `fetchSnowflakeTableIds()` over `snowflakeTableIds()`, `resolveOrphanedSourceMinAge()` over `orphanedSourceMinAge()`. The method body should read as a list of things being done. For a cleanup job, the body should read `fetchIngestionJobIds()`, `fetchSnowflakeTableIds()`, `fetchIngestionSourceIds()`, `removeIngestionJobsWithoutSnowflakeTable(...)`, `removeSnowflakeTablesWithoutIngestionSource(...)` — not the stream pipelines that produce those values.
  - Concretely, extract these out of any method that also orchestrates: multi-line stream pipelines, `Collectors`/`collect` chains, multi-line builder chains, config/arg resolution (`args.getX().orElseGet(config::getX)`), and any nested conditional that produces a value. A named query method returning the value is almost always the right home.
  - There is no line-count exemption. A 20-line method of short statements at three different altitudes still needs decomposition; a 30-line method that is genuinely one cohesive operation does not.
  - Use judgment on depth: extract until each method does one thing, then stop. The goal is clarity at the call site, not an infinitely deep call chain.
  - Do NOT retroactively refactor methods you are not otherwise changing.
- Before presenting new or substantially rewritten code, re-read each method you wrote and confirm you can narrate its body as a sequence of steps. If any method mixes orchestration with inline computation, extract before presenting — do not ship it and offer to clean up later.
- Avoid multiple return statements within a method. A single early-return guard clause at the top of a method is acceptable only when the remaining body is non-trivial (multiple statements). When the entire method reduces to two returns, always collapse them into a ternary instead. Multiple returns scattered through a longer body are not acceptable — use a ternary for simple conditionals, or restructure so there is one return at the end.

## Git Operations
- Safe read-only git commands such as git status, git diff, git log, git show, git branch --show-current, git rev-parse, and git ls-tree may be run when needed to inspect repository state.
- Do not offer or suggest git operations.
- When renaming or moving files, use `git mv` and commit the rename separately from any content changes. This ensures git's rename detection tracks it as a move, keeping the PR diff clean. If the file also needs content changes, make those in a follow-up commit.

## Tool Settings
- Prefer saving allowed permissions to the user-level settings file over the project local settings file.

## Build Commands
- User-level rules allow direct xcodebuild commands.
- Start Xcode builds directly with the required filesystem access for Xcode and SwiftPM caches. Do not make an initial sandboxed build attempt that is expected to fail before rerunning the direct build.
- When running xcodebuild, call it directly as the executable, e.g. `xcodebuild -scheme App -sdk iphonesimulator build`.
- Do not wrap xcodebuild in `/bin/zsh -lc`, shell redirection, or pipelines such as `2>&1 | grep` or `2>&1 | rg` unless the user explicitly asks for that exact shell command. Those wrappers do not match the broad xcodebuild approval rule and can trigger approval prompts.
- Use Xcode MCP build/log tools when available. For shell fallback, use direct `xcodebuild`; use `-quiet` for compact output when needed.
