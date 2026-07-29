## Communication Style
- Be clear, concise, and direct. Use 5 words when 5 will do.
- Default to short answers; let the user ask for more detail.
- Prefer bulleted lists over walls of text where the content is list-like.

## Collaboration
- When authoring commit messages and PR summaries, DO NOT include references to AI coding assistants (e.g., Codex, Claude Code, Copilot).
- When you fix code in response to PR feedback, ALWAYS mark that feedback comment as resolved. 
- When instructed by the user not to implement a fix suggested in PR feedback, ALWAYS respond to that feedback with a brief comment explaining why it will not be implemented then mark that feedback comment as resolved.
- When responding to feedback or making a follow-up tweak to a commit you created on the current branch, amend that commit rather than creating a new one. Err on the side of amending — transient commits like "Fixed typo," "Renamed variable," or "Fixed build" should never appear in branch history. Keep the branch history as a clean sequence of logical, meaningful commits that tell the story of what you did and why. Never amend commits that already exist in the base branch.

## Coding Style
- Prefer self-documenting code over comments.
- Do not make drive-by changes to code you are not otherwise modifying. No renaming variables "for clarity," no reformatting untouched lines, no reorganizing imports in files you didn't change. Keep diffs focused on the task at hand.
- Never add or remove comments unless explicitly asked to do so.
- All control-flow blocks (`if`, `else`, `else if`, `for`, `while`, `do`, `switch`, `try`, `catch`, `finally`) MUST have a blank line before the opening line and a blank line after the closing line. The only exceptions are:
  - No blank line before the block when its opening line is the first statement in its enclosing method/constructor/lambda body
  - No blank line after the block when its closing line is the last statement in its enclosing method/constructor/lambda body
  - Applies to all languages (Java, TypeScript/JavaScript, Python, etc.)
  - Consecutive `else`/`else if`/`catch`/`finally` clauses are part of the same block — the blank-line rule applies to the outer block as a whole, not between the chained clauses
- Methods within a class are ordered: public methods before private methods. Within each visibility group, order methods by call hierarchy using breadth-first traversal — callers appear before their callees, and all direct callees of a method are listed before any of those callees' own sub-callees. Example: if A calls a, b, c; b calls b1, b2; and c calls c1, c2 — the order is: A, a, b, c, b1, b2, c1, c2. Applies to all languages (Java, TypeScript/JavaScript, Python, etc.). Do not reorder existing methods unless asked explicitly to do so but when creating new methods, their placement should follow these ordering rules.
- When writing new methods or substantially rewriting existing ones: if a method body performs multiple distinct steps or responsibilities, extract each step into a well-named private method so the parent method reads as a short sequence of high-level operations (almost like prose or a bulleted list). Do NOT retroactively refactor methods you aren't otherwise changing. Use judgment on depth — the goal is clarity at the call site, not an infinitely deep call chain. A method that does one cohesive thing in 15–20 lines is fine left inline; a method that chains 3+ distinct responsibilities across 40+ lines should be decomposed.
- Avoid multiple return statements within a method. A single early-return guard clause at the top of a method is fine, but multiple returns scattered through the body are not — use a ternary instead for simple conditionals, or restructure so there is one return at the end.

## Git Operations
- Safe read-only git commands such as git status, git diff, git log, git show, git branch --show-current, git rev-parse, and git ls-tree may be run when needed to inspect repository state.
- Do not offer or suggest git operations.

## Tool Settings
- Prefer saving allowed permissions to the user-level settings file over the project local settings file.