# iclf-standard - Planned Issues

This file tracks intended GitHub issues before creation.

**Legend:**
- `[GH: -]` = Not yet created in GitHub
- `[GH: #123]` = Created, issue number 123

---

## Content

### ~~Add missing samples~~ `[GH: -]`
- **Status:** Done
- **Labels:** `content`
- **Description:** Sync samples from other projects and add new reference files
- **Acceptance Criteria:**
  - [x] Add `maracatu-eta.iclf` from iclf-parser
  - [x] Review and resolve `aroma.iclf` version differences - kept iclf-standard version

### Add diverse genre/language samples `[GH: -]`
- **Status:** Planned
- **Labels:** `content`, `enhancement`
- **Description:** Expand sample collection with diverse genres and languages
- **Acceptance Criteria:**
  - [ ] Add samples from different music genres (jazz, classical, folk, etc.)
  - [ ] Add samples with non-English lyrics (Spanish, Portuguese, etc.)
  - [ ] Add samples demonstrating advanced ICLF features

## Chord Validation

### ~~Support Brazilian chord notation in chord regex~~ `[GH: #1]`
- **Status:** Done ✅
- **Labels:** `enhancement`, `content`
- **Description:** The chord validation regex does not support Brazilian music notation conventions widely used in bossa nova and choro. These styles use extra-rich chord formations that differ from standard international notation.
- **Failing chords from real imports:**
  - `D#m7(5-)` — minus for flat inside parentheses
  - `A6(9)` — bare number in parentheses (add notation)
  - `A7M(6/11+)` — `7M` for major 7, compound interval, plus for sharp
- **Conventions to support:**
  - `7M` as major 7 shorthand (e.g., `C7M` = `Cmaj7`)
  - `-` for flat inside parentheses: `(5-)`, `(9-)`, `(11-)`, `(13-)`
  - `+` for sharp inside parentheses: `(5+)`, `(9+)`, `(11+)`, `(13+)`
  - Bare numbers in parentheses: `(9)`, `(11)`, `(13)`, `(4)`
  - Compound intervals: `(6/9)`, `(6/11+)`, `(9/13)`, etc.
- **Acceptance Criteria:**
  - [x] Update chord regex in `directives.json` to support all Brazilian conventions
  - [x] Update regex description to document new patterns

---

## Issue Template

```markdown
### Issue title `[GH: -]`
- **Status:** Planned | In Progress | Done
- **Labels:** `category`
- **Description:** Brief description
- **Acceptance Criteria:**
  - [ ] Criterion 1
```
