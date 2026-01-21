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
- **Validation**: Must be a valid chord: N.C. (no chord), or root (A-G), optional accidental (# or b), optional minor (m or min), optional quality (maj, dim, °, ˚, ø, +, aug), optional suspension (sus2, sus4), optional extension (6, 7, 9, 11, 13), optional add (add9, add11, add13), optional alterations (b5, #5, b9, #9, #11, b13 with optional parentheses), optional bass note (/E). Examples: C, Am, Cmaj7, Cmmaj7, C7sus4, Cadd9, C7b9, Dm7b5, Bb7/Ab, N.C.
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


### Chord Variations

The following variations are supported in chord notation:

#### Accidental

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `sharp` | `#` | Sharp accidental | C#, F#, G#, A#, D#, E#, B# |
| `flat` | `b` | Flat accidental | Bb, Eb, Ab, Db, Gb, Cb, Fb |

#### Add

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `add9` | `add9` | Added 9th without 7th | Cadd9, Gadd9, Amadd9, Dadd9 |
| `add11` | `add11` | Added 11th | Cadd11, Dadd11, Gadd11 |
| `add13` | `add13` | Added 13th | Cadd13, Dadd13 |

#### Alteration

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `b5` | `b5` | Flat 5th alteration | C7b5, G7b5, Dm7b5 |
| `#5` | `#5` | Sharp 5th alteration | C7#5, G7#5, E7#5 |
| `b9` | `b9` | Flat 9th alteration | C7b9, G7b9, B7b9, C7(b9) |
| `#9` | `#9` | Sharp 9th alteration (Hendrix chord) | C7#9, E7#9, G7#9, C7(#9) |
| `#11` | `#11` | Sharp 11th alteration (lydian dominant) | C7#11, F7#11, Cmaj7#11, C7(#11) |
| `b13` | `b13` | Flat 13th alteration | C7b13, A7b13, G7b13, A7(b13) |

#### Augmented

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `augmented-aug` | `aug` | Augmented chord using aug suffix | Caug, Gaug, Eaug |
| `augmented-plus` | `+` | Augmented chord using + symbol | C+, G+, E+ |

#### Basic

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `root` | `A, B, C, D, E, F, G` | Root notes A through G |  |

#### Bass

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `slash` | `/` | Chord with specified bass note. The note after / indicates the lowest note to play, which may be a chord tone (inversion) or non-chord tone (added bass). Commonly used for bass lines and voice leading. | C/E, C/G, Am/G, G/B, D/F#, C/Bb, Bb7/Ab, Ebmmaj7/Gb |
| `bass-line` | `-` | Slash chords used in sequence to create melodic bass movement. Common patterns include descending (C → C/B → Am → Am/G), ascending (Am → Am/B → C), and chromatic lines (C → C/B → C/Bb → C/A). Essential for voice leading in folk, pop, jazz, and bossa nova. | C/B, Am/G, Am/F#, D/F#, G/F, Em/D, C/Bb, Dm/C, Fmaj7/E, E7/G# |

#### Diminished

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `diminished-dim` | `dim` | Diminished chord using dim suffix | Cdim, Bdim, Fdim, Cdim7 |
| `diminished-degree` | `°` | Diminished chord using ° (degree sign U+00B0) | C°, B°, F°, C°7 |
| `diminished-ring` | `˚` | Diminished chord using ˚ (ring above U+02DA) | C˚, B˚, F˚, C˚7 |

#### Extension

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `6th` | `6` | 6th chord - adds major 6th to triad | C6, Am6, Gm6, Dm6, Ebm6 |
| `7th` | `7` | 7th chord - adds 7th degree | C7, Cm7, Cmaj7, Cdim7, Am7, G7, Bb7 |
| `9th` | `9` | 9th chord - extends through 9th degree | C9, Cm9, Cmaj9, G9, Am9 |
| `11th` | `11` | 11th chord - extends through 11th degree | C11, Cm11, G11, Am11 |
| `13th` | `13` | 13th chord - extends through 13th degree | C13, Cm13, G13, D13 |

#### Half Diminished

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `half-diminished-ø` | `ø` | Half-diminished chord using ø symbol | Cø, Dø7, F#ø, Bø |
| `half-diminished-m7b5` | `m7b5` | Half-diminished chord using m7b5 notation | Dm7b5, F#m7b5, Bm7b5, Em7b5 |

#### Major

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `major` | `maj` | Explicit major quality | Cmaj, Cmaj7, Cmaj9, Bbmaj7, Ebmaj7, Fmaj7 |

#### Minor

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `minor-m` | `m` | Minor chord using m suffix | Am, Dm, Em, Bm, F#m, C#m, Gm |
| `minor-min` | `min` | Minor chord using min suffix | Amin, Dmin, Emin |

#### Minor Major

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `minor-major` | `mmaj7` | Minor chord with major 7th | Cmmaj7, Ammaj7, Ebmmaj7, Ebmmaj7/Gb |

#### Pattern

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `bass-line` | `-` | Slash chords used in sequence to create melodic bass movement. Common patterns include descending (C → C/B → Am → Am/G), ascending (Am → Am/B → C), and chromatic lines (C → C/B → C/Bb → C/A). Essential for voice leading in folk, pop, jazz, and bossa nova. | C/B, Am/G, Am/F#, D/F#, G/F, Em/D, C/Bb, Dm/C, Fmaj7/E, E7/G# |

#### Quality

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `minor-m` | `m` | Minor chord using m suffix | Am, Dm, Em, Bm, F#m, C#m, Gm |
| `minor-min` | `min` | Minor chord using min suffix | Amin, Dmin, Emin |
| `diminished-dim` | `dim` | Diminished chord using dim suffix | Cdim, Bdim, Fdim, Cdim7 |
| `diminished-degree` | `°` | Diminished chord using ° (degree sign U+00B0) | C°, B°, F°, C°7 |
| `diminished-ring` | `˚` | Diminished chord using ˚ (ring above U+02DA) | C˚, B˚, F˚, C˚7 |
| `half-diminished-ø` | `ø` | Half-diminished chord using ø symbol | Cø, Dø7, F#ø, Bø |
| `half-diminished-m7b5` | `m7b5` | Half-diminished chord using m7b5 notation | Dm7b5, F#m7b5, Bm7b5, Em7b5 |
| `augmented-aug` | `aug` | Augmented chord using aug suffix | Caug, Gaug, Eaug |
| `augmented-plus` | `+` | Augmented chord using + symbol | C+, G+, E+ |
| `major` | `maj` | Explicit major quality | Cmaj, Cmaj7, Cmaj9, Bbmaj7, Ebmaj7, Fmaj7 |
| `minor-major` | `mmaj7` | Minor chord with major 7th | Cmmaj7, Ammaj7, Ebmmaj7, Ebmmaj7/Gb |

#### Slash

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `slash` | `/` | Chord with specified bass note. The note after / indicates the lowest note to play, which may be a chord tone (inversion) or non-chord tone (added bass). Commonly used for bass lines and voice leading. | C/E, C/G, Am/G, G/B, D/F#, C/Bb, Bb7/Ab, Ebmmaj7/Gb |
| `bass-line` | `-` | Slash chords used in sequence to create melodic bass movement. Common patterns include descending (C → C/B → Am → Am/G), ascending (Am → Am/B → C), and chromatic lines (C → C/B → C/Bb → C/A). Essential for voice leading in folk, pop, jazz, and bossa nova. | C/B, Am/G, Am/F#, D/F#, G/F, Em/D, C/Bb, Dm/C, Fmaj7/E, E7/G# |

#### Special

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `no-chord` | `N.C.` | No chord / tacet - indicates silence or no accompaniment | N.C. |

#### Suspended

| Name | Symbol | Description | Examples |
|------|--------|-------------|----------|
| `sus2` | `sus2` | Suspended 2nd - replaces 3rd with 2nd | Csus2, Dsus2, Asus2, Gsus2 |
| `sus4` | `sus4` | Suspended 4th - replaces 3rd with 4th | Csus4, Dsus4, Gsus4, G7sus4, D7sus4 |

#### Common Bass Line Patterns

| Pattern | Sequence |
|---------|----------|
| descending major | C → C/B → Am → Am/G → F |
| descending minor | Am → Am/G → Am/F# → Fmaj7 |
| ascending | Am → Am/B → C → C/D → G |
| chromatic descent | C → C/B → C/Bb → C/A |
| jazz turnaround | Cmaj7 → Am7 → Dm7 → G7/F → Em7 → A7/C# |


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
