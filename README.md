# Inline Chorded Lyrics Format (ICLF) Specification v1.0

## Introduction
The Inline Chorded Lyrics Format (ICLF, pronounced "eye-see-el-ef") is a plain-text standard for notating song lyrics with inline chords. “Chorded” means lyrics are equipped with chords placed precisely at syllables or words, ensuring readability and musical accuracy.

ICLF is designed for:
- **Human Readability**: Musicians can open an ICLF file (`.iclf`) and play instantly.
- **Syllable-Precise Chords**: Chords like `[Am]Parla` align exactly with lyrics.
- **Extensibility**: Supports notes (`#` or non-reserved `{key: value}`) and custom directives via community proposals.
- **Cross-Platform Sharing**: Plain text ensures compatibility with any app or device.
- **Accessibility**: Screen-reader-friendly for all users.

ICLF is a secular, genre-agnostic format, unaffiliated with other organizations (e.g., International Christian Fellowship).

## Syntax
- **Chords**: `[Chord]` before a syllable/word (e.g., `[Am]Parla`).
- **Directives**: `{key: value}` for metadata or structure (e.g., `{title: Song Name}`).
- **Notes**:
  - `# Comment`: Freeform annotations (e.g., `# Strum gently`).
  - Non-reserved `{key: value}`: Custom notes (e.g., `{mood: Romantic}`).
- **Sections**: `{section: Name}` (e.g., `{section: Verse}`).

## Directives

Directives are reserved `{key: value}` pairs with defined roles, listed in [`directives.json`](./directives.json). Each directive includes validation rules, uniqueness constraints, and examples.

## `title`

*Description*: Sets the song title.

*Instructions*: Display as the song’s title in the UI. Store as metadata for search or sharing.

*Scope*: global

*Required*: Yes

*Unique*: Yes

*Example*: Parla Più Piano

*Validation*: None

## `key`

*Description*: Specifies the musical key of the song or section.

*Instructions*: Display as the song’s key in the UI. Use for transposition calculations. If within a section, applies to that section only.

*Scope*: global or section

*Required*: Yes

*Unique*: Yes

*Default*: C

*Example*: Am

*Validation*: Must be a musical key: A-G, optional # or b, optional m, maj, min, dim, °, aug, sus2, or sus4 (e.g., C, Am, F#, Bbmaj).

## `composer`

*Description*: Specifies the song’s composer.

*Instructions*: Display as the composer in the UI, typically below the title. Store as metadata for attribution.

*Scope*: global

*Required*: No

*Unique*: Yes

*Example*: Nino Rota

*Validation*: None

## `arranged_by`

*Description*: Specifies the arranger or transcriber of the song or ICLF file.

*Instructions*: Display as metadata in the UI, typically below the title or composer. Store for attribution or search.

*Scope*: global

*Required*: No

*Unique*: Yes

*Example*: Transcribed by Maria

*Validation*: Must be a non-empty string (e.g., Transcribed by Maria).

## `creation_date`

*Description*: Specifies the creation date of the ICLF file.

*Instructions*: Display as metadata in the UI or use for sorting songs. Store as ISO 8601 date (YYYY-MM-DD).

*Scope*: global

*Required*: No

*Unique*: Yes

*Example*: 2025-04-28

*Validation*: Must be an ISO 8601 date in YYYY-MM-DD format (e.g., 2025-04-28).

## `section`

*Description*: Defines a new section (e.g., Verse, Chorus).

*Instructions*: Start a new section in the data model. Display the section name as a heading in the UI.

*Scope*: section

*Required*: No

*Unique*: No

*Example*: Verse

*Validation*: None

## `repeat`

*Description*: Instructs to repeat a section a specified number of times.

*Instructions*: Parse as 'Section, Nx' (e.g., 'Chorus, 2x'). Display a repeat indicator (e.g., 'Repeat Chorus 2x') or duplicate section content in the UI. Validate that Section exists.

*Scope*: section

*Required*: No

*Unique*: No

*Example*: Chorus, 2x

*Validation*: Must be 'Section, Nx' where Section is a section name and N is a positive integer (e.g., Chorus, 2x).

## `capo`

*Description*: Indicates the capo position on a guitar.

*Instructions*: Display as 'Capo: N' in the UI. Use for chord transposition if requested.

*Scope*: global

*Required*: No

*Unique*: Yes

*Default*: 0

*Example*: 2

*Validation*: Must be a non-negative integer between 0 and 12 (e.g., 2).

## `tempo`

*Description*: Sets the tempo in beats per minute (BPM).

*Instructions*: Display as 'Tempo: N BPM' in the UI. Optionally integrate with a metronome feature.

*Scope*: global

*Required*: No

*Unique*: Yes

*Example*: 80

*Validation*: Must be a positive integer between 20 and 300 (e.g., 80).

## `strumming`

*Description*: Specifies a strumming pattern for a section or song.

*Instructions*: Display as a rhythmic guide (e.g., 'D-DU-UDU'). Optionally integrate with a metronome or visual guide in the UI.

*Scope*: global or section

*Required*: No

*Unique*: No

*Example*: D-DU-UDU

*Validation*: Must be a sequence of D (down), U (up), R (rest), or - (pause) (e.g., D-DU-UDU).

## `tuning`

*Description*: Specifies the instrument tuning as a text attribute.

*Instructions*: Display as metadata in the UI (e.g., 'Tuning: EADGBE'). Store for reference; no structured parsing in v1.0.

*Scope*: global

*Required*: No

*Unique*: Yes

*Example*: EADGBE

*Validation*: None



## Chords

Notates a chord aligned with a syllable or word. Optional attributes specify inversions, voicings, or performance details.

- **Syntax**: `[Chord[:Attribute, Value][Attribute2, Value2]]`
- **Validation**: Must be a valid chord: A-G, optional # or b, optional quality (m, maj, min, dim, °, aug, sus2, sus4, add9), optional extension (6, 7, 9, 11, 13), optional altered note ((b5), (#9), etc.), optional bass note (/E) (e.g., C, Am, D7(b9)13, Dmaj9, C6, D9).
- **Instructions**: Display the chord above or before the associated text. Parse attributes to adjust display (e.g., show C/E for [C:inversion, 1]). No diagrams in v1.0.

### Chord Attributes

#### `inversion`

*Description*: Specifies the chord inversion (e.g., first inversion for C/E).

*Instructions*: Display as Chord/Bass (e.g., C/E for [C:inversion, 1]).

*Example*: 1

*Validation*: Must be a non-negative integer (0 for root position, 1 for first inversion, etc., up to 3 for seventh chords).

#### `voicing`

*Description*: Specifies a chord voicing or fingering (e.g., open or barre).

*Instructions*: Display the chord with the specified voicing (e.g., Am/open).

*Example*: open

*Validation*: Must be a voicing name (e.g., open, barre).

#### `capo`

*Description*: Transposes the chord as if played with a capo.

*Instructions*: Display the transposed chord (e.g., [C:capo, 2] as D).

*Example*: 2

*Validation*: Must be a non-negative integer between 0 and 12 (e.g., 2).

#### `bass`

*Description*: Specifies one or more bass notes for the chord, including runs.

*Instructions*: Display as Chord/Bass or indicate bass run (e.g., Am/A-C-E for [Am:bass, A-C-E]).

*Example*: A-C-E

*Validation*: Must be one or more musical notes separated by hyphens (A-G, optional # or b) (e.g., G, A-C-E).



## Notes
Notes are annotations for performance tips, reminders, or custom metadata:
- **# Notes**: Simple comments prefixed with `#` (e.g., `# Strum gently`). Display as italicized text or in a dedicated UI section. Any text following `#` is valid (whitespace trimmed).
- **Non-Reserved Directives**: Any `{key: value}` not listed in [`directives.json`](./directives.json) (e.g., `{practice: Arpeggiate softly}`). Apps may display as text, balloons, or custom features.

## Extensibility
Non-reserved `{key: value}` notes can evolve into standard directives. Propose new directives at [github.com/yourusername/iclf-standard](https://github.com/yourusername/iclf-standard). Apps should treat unknown `{key: value}` as notes.

## Example
```
{title: Parla Più Piano}
{key: Am}
{composer: Nino Rota}
{arranged_by: Transcribed by Maria}
{creation_date: 2025-04-28}
{tempo: 80}
{mood: Romantic}
{section: Verse}
[Am]Parla più [Dm]pia-[Am]no e nessuno sen-[Am]tirà
# Strum gently
{practice: Arpeggiate softly}
[Am]Il nostro [A7]amo-[Dm]re lo viviamo io e te
# Emphasize ‘verità’
[E7]Nessuno sa la veri-[Am]tà
```

## Parsing
- **Load Directives**: Read `directives.json` to identify reserved `{key: value}`.
- **Chords**: Use regex `\\[([^\]]+)\\]([^\[]+)` to extract chord-text pairs.
- **Notes**: Store `#` comments and non-reserved `{key: value}` for display or app-specific features.
- **Validation**: Check `{key: value}` against `validation` rules in `directives.json`. Warn on invalid inputs.
- **Uniqueness**: Warn if unique directives (e.g., `{title: ...}`) appear multiple times.
- **Unknown Directives**: Treat as notes for forward compatibility.

## License
This specification is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## Contributing
Submit issues or pull requests at [github.com/yourusername/iclf-standard](https://github.com/yourusername/iclf-standard).
