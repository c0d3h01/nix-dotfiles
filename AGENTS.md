# AGENTS.md

## Commit Rules For Agents

When making git commits in this repository, follow these rules:

### 1. Split Changes Into Logical Commits

- Commit related changes together.
- Do not mix unrelated refactors, fixes, formatting, and feature work in
  the same commit.
- Prefer multiple small commits over one large mixed commit.
- Group commits by module ownership or user-facing behavior when possible.

### 2. Protect Existing Work

- Never revert or overwrite unrelated user changes.
- Inspect `git status` and the diff before committing.
- Stage only the files that belong to the current logical change.
- If a new file is required for evaluation, make sure it is staged before
  running flake-based validation.

### 3. Commit Message Format

Use the Conventional Commits style:

`<type>(<scope>): <description>`

Examples:

- `feat(input): add fcitx5 input method`
- `refactor(audio): fold bluetooth into audio`
- `chore(power): drop powertop tuning`

### 4. Commit Message Rules

- Use lowercase commit types such as `feat`, `fix`, `docs`, `style`,
  `refactor`, `test`, `perf`, and `chore`.
- Keep the subject line short.
- Use imperative mood.
- Do not end the subject line with a period.
- Add a blank line between the subject and body.
- Wrap body lines at about 72 characters.
- Use `-` bullets in the body when listing multiple changes.

### 5. Recommended Commit Workflow

1. Review `git status --short`.
2. Review the relevant diffs.
3. Group files into one logical change.
4. Stage only that group.
5. Commit with a Conventional Commit message and short explanatory body.
6. Repeat until the worktree is clean.

### 6. Validation Before Final Handoff

- Prefer lightweight validation before or after the commit series.
- For this repository, `nix eval` of the affected flake outputs is a good
  baseline check.
- Confirm the worktree is clean with `git status --short` after finishing.
