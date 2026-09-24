---
title: Cursor workflow and new-laptop transfer
updated: 2026-09-24
version: 1.0
---

# Cursor workflow and new-laptop transfer

How this Mac uses Cursor, how to move that setup, and a few tighter habits for the new laptop.

## Executive summary

Cursor is split into three layers:

1. **Account** — sign-in, User Rules, some settings. These follow the Cursor account, not the SSD.
2. **Files you own** — rules and skills in `~/Work/3_Resources/code/cursor_rules_and_documentation/`, symlinked from `~/.cursor/`.
3. **Local app data** — chats, MCP config, `state.vscdb`. These live in `~/.cursor` and `~/Library/Application Support/Cursor/` and only move if you copy them.

Restore **Work and personal folders to the same paths** before opening old chats. Chats are bound to those paths.

## How work is split

| Kind of work | Open this folder | What Cursor should follow |
|---|---|---|
| OP5 iOS automation | `~/Work/op5ios-atm` | Skills `op5ios-automate-test-case`, `op5ios-check-tc-automatable`; rules for JSON→script, BLE, PR text |
| Requirement finder | `~/Work/requirement_finder` | `requirement-finder-*.mdc` |
| Shell / Python tools | `~/Work/3_Resources/code/bash_projects` or `python_projects` | Always-on rule `user-script-locations` |
| Learning notes, summaries, calls | `~/personal/second-brain` | Skills `summarize`, `summarize-call`, `transcribe-youtube`; rule `learning-docs-directory` |
| Dotfiles / shell | `~/personal/dotfiles` | Editor config only; do not put work scripts here |
| Resume / applications | career wiki under `~/personal` | Skill `resume-tailor` |

Do not use one long chat for work automation and personal notes. Start a new chat when the repo changes.

## Phrases that already trigger the right skill

Say the short form. Do not paste the skill.

| You say | Skill |
|---|---|
| `Check if TCs in BLE_Extra.json are automatable` | `op5ios-check-tc-automatable` |
| `automate TC-43108 as ts_ble_15` | `op5ios-automate-test-case` |
| `plan TC-43200 as ts_ble_16` | Same skill, plan only until you approve |
| Paste a URL and ask to summarize | `summarize` |
| Drop a call recording | `summarize-call` |
| Transcribe a YouTube URL | `transcribe-youtube` |
| Tailor a resume to a job posting | `resume-tailor` |
| `/i-have-adhd` | `i-have-adhd` until you say `stop adhd mode` |

Default order for test cases: **automatability check first**, then only Fully (or approved Partially) automatable cases go into `tcs_to_automate/`, then `automate …`.

## Rules that apply without asking

Source of truth: `~/Work/3_Resources/code/cursor_rules_and_documentation/rules/`  
Linked as `~/.cursor/rules`.

| Rule | When it applies |
|---|---|
| `user-script-locations.mdc` | Always. `.sh` → `bash_projects`, `.py` tools → `python_projects`, L3 tests → `op5ios-atm` only |
| `learning-docs-directory.mdc` | How-tos and study notes → `~/personal/second-brain/` |
| `op5ios-*` | When you are in op5ios-atm or ask to automate / check TCs / write a PR |
| `libre3-ble-cleanup.mdc` | L3 sensor activation and BLE timing |
| `requirement-finder-*` | When that repo is open |
| `test-case-inventory-report.mdc` | Inventory reports over `test_cases/` |

## User Rules to recreate if sign-in does not restore them

Cursor **Settings → Rules → User Rules**. Paste these if the new account is empty. They are not in the rules repo.

1. Only create git commits when asked. Never update git config. Never force-push or skip hooks unless asked. Commit message via HEREDOC. Do not commit secrets.
2. For GitHub tasks use `gh`. When asked for a PR: status, diff, log, push, then `gh pr create` with Summary and Test plan.
3. For web UI changes, verify the flow in the browser (click, type, navigate). A screenshot alone is not verification.
4. State points in affirmative language. Avoid contrastive negation such as “X, not Y.”

## Editor defaults on this Mac

`~/Library/Application Support/Cursor/User/settings.json`:

- Theme: Catppuccin Mocha
- Sidebar on the right
- Vim extension disabled (`vim.disableExtension: true`)

MCP (`~/.cursor/mcp.json`), all via `npx` (Node required):

- `context7` — current library docs
- `playwright` — browser checks
- `tts` — `mcp-say`

No API keys are stored in `mcp.json` today. Still treat the file as private. Do not put it on work OneDrive.

## Transfer to the new laptop

Do this **after** Jamf enrollment, Homebrew, and restoring `~/Work` and `~/personal`. Full machine steps: `~/personal/dotfiles/scripts/migrate/migration-kit/NEW_LAPTOP.md`.

### 1. Copy the context file

It already rides inside the personal backup:

`personal-backup/personal/second-brain/06_Research/how-to/cursor-workflow-new-laptop.md`

On the new Mac, after restore, the path is:

`~/personal/second-brain/06_Research/how-to/cursor-workflow-new-laptop.md`

A copy also sits in the migration kit: `migration-kit/cursor-workflow-new-laptop.md`.

### 2. Restore Cursor data

Quit Cursor on the old Mac before the last backup so chat DB files are consistent.

On the new Mac: install Cursor, open it once, quit, then:

```bash
DISK="/Volumes/<Disk>/mac-migrate-20260923"
rsync -aH "$DISK/cursor-migrate/dot-cursor/" ~/.cursor/
rsync -aH "$DISK/cursor-migrate/CursorUser/" \
  "$HOME/Library/Application Support/Cursor/User/"
cp "$DISK/cursor-migrate/mcp.json" ~/.cursor/mcp.json
chmod 600 ~/.cursor/mcp.json
ln -sfn ~/Work/3_Resources/code ~/Documents/Codes
ln -sfn ~/Documents/Codes/cursor_rules_and_documentation/rules ~/.cursor/rules
ln -sfn ~/Documents/Codes/cursor_rules_and_documentation/skills ~/.cursor/skills
```

`restore-from-ssd.sh` does the same restore.

### 3. First session

1. Sign in to the same Cursor account.
2. Confirm User Rules. Paste the four rules above if they are missing.
3. Install Node so `npx` MCP servers start. Settings → MCP: context7, playwright, tts.
4. Open folders at the **same paths**: `~/Work/op5ios-atm`, `~/Work/requirement_finder`, `~/personal/second-brain`, `~/personal/dotfiles`.
5. In the first work chat, ask: “List the op5ios skills you can see.” If the list is empty, the symlinks in step 2 failed.
6. If a repo’s old chats are missing: open it once, compare `workspaceStorage/<hash>/workspace.json` with the copy on the SSD, and merge the old hash folder into the new one.

### 4. First message on the new laptop

Open `~/personal/dotfiles` or `~/personal/second-brain` and say:

```
Read ~/personal/second-brain/06_Research/how-to/cursor-workflow-new-laptop.md
and confirm rules, skills, and MCP match this machine.
```

## Day-to-day workflow

1. **Plan mode** for anything that touches many files, a migration, or a test-script design. Approve the plan, then switch to Agent.
2. **Agent mode** only after the plan is accepted, or for a single obvious edit.
3. **Name the target** in the first sentence: `automate TC-43108 as ts_ble_15`, not “automate this test.”
4. **Attach the file** with `@` instead of pasting JSON, logs, or long diffs.
5. **One repo per chat.** Work chats stay in `~/Work/...`. Personal chats stay in `~/personal/...`.
6. **Commits and PRs only when you ask.** Review the diff before you say yes.
7. For a long setup or a dense plan, start with `/i-have-adhd` so the next action stays on the first line.
8. Use **context7** when the question is “what does this library’s API look like now,” and **playwright** when a UI change needs a real click-through.

## Improvements over the current setup

| Gap | Change on the new laptop |
|---|---|
| User Rules are easy to lose | After sign-in, confirm the four rules above. They are not in git. |
| Chats depend on exact paths | Keep username `jcastaneda` and the `~/Work` / `~/personal` layout. Recreate the `~/Documents/Codes` symlink before opening Cursor. |
| Last backup can miss an open chat DB | Quit Cursor, then re-run `backup-to-ssd.sh` the day you switch machines. |
| Skills only exist as a symlink into Work | Confirm `cursor_rules_and_documentation` is committed and pushed, so a fresh clone can rebuild the symlinks. |
| MCP fails with no Node | Install Node before the first Agent session. |
| One giant chat mixes work and personal context | New chat per repo. Personal vault never goes into work OneDrive. |
| Plan skipped on large edits | Plan mode first for test automation, migrations, and anything over a few files. |
| UI “done” without using the app | For web UI, exercise the flow. Playwright MCP is for that check. |
| ADHD sessions bury the next step | `/i-have-adhd` for restore day and for multi-step test-case work. |

## Verify

- [ ] `ls -l ~/.cursor/rules ~/.cursor/skills` both point at `cursor_rules_and_documentation`
- [ ] A work chat sees `op5ios-automate-test-case`
- [ ] A second-brain chat sees `summarize` and writes under `~/personal/second-brain/`
- [ ] Settings → MCP shows context7, playwright, tts connected
- [ ] An old chat opens for `~/Work/op5ios-atm`
- [ ] User Rules are present
- [ ] `~/personal` is not inside a work cloud folder

## Related paths

| What | Path |
|---|---|
| This doc | `~/personal/second-brain/06_Research/how-to/cursor-workflow-new-laptop.md` |
| Rules and skills repo | `~/Work/3_Resources/code/cursor_rules_and_documentation/` |
| Machine checklist | `~/personal/dotfiles/scripts/migrate/migration-kit/NEW_LAPTOP.md` |
| Backup script | `~/personal/dotfiles/scripts/migrate/backup-to-ssd.sh` |
| Restore script | `~/personal/dotfiles/scripts/migrate/restore-from-ssd.sh` |
| Local backup (if SSD not mounted) | `~/mac-migrate-20260923/` |
