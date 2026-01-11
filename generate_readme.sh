#!/bin/bash
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install it with 'sudo apt install jq' (Ubuntu) or 'brew install jq' (macOS)."
    exit 1
fi
json_file="directives.json"
if [ ! -f "$json_file" ]; then
    echo "Error: $json_file not found."
    exit 1
fi
json=$(cat "$json_file")
version=$(echo "$json" | jq -r '.version')
directives_section="## Directives"$'\n\n'"Directives are reserved \`{key: value}\` pairs with defined roles, listed in [\`directives.json\`](./directives.json). Each directive includes validation rules, uniqueness constraints, and examples."$'\n\n'
while IFS= read -r dir; do
    name=$(echo "$dir" | jq -r '.name')
    desc=$(echo "$dir" | jq -r '.description')
    inst=$(echo "$dir" | jq -r '.instructions')
    scope=$(echo "$dir" | jq -r '.scope')
    required=$(echo "$dir" | jq -r '.required' | grep -q 'true' && echo 'Yes' || echo 'No')
    unique=$(echo "$dir" | jq -r '.unique' | grep -q 'true' && echo 'Yes' || echo 'No')
    example=$(echo "$dir" | jq -r '.example // "None"')
    validation=$(echo "$dir" | jq -r '.validation.description // "None"')
    default=$(echo "$dir" | jq -r '.default // ""')
    
    directives_section+="## \`$name\`"$'\n\n'
    directives_section+="*Description*: $desc"$'\n\n'
    directives_section+="*Instructions*: $inst"$'\n\n'
    directives_section+="*Scope*: $scope"$'\n\n'
    directives_section+="*Required*: $required"$'\n\n'
    directives_section+="*Unique*: $unique"$'\n\n'
    if [ -n "$default" ]; then
        directives_section+="*Default*: $default"$'\n\n'
    fi
    directives_section+="*Example*: $example"$'\n\n'
    directives_section+="*Validation*: $validation"$'\n\n'
done < <(echo "$json" | jq -c '.directives[]')
chords=$(echo "$json" | jq -r '.chords')
chords_desc=$(echo "$chords" | jq -r '.description')
chords_inst=$(echo "$chords" | jq -r '.instructions')
chords_syntax=$(echo "$chords" | jq -r '.syntax')
chords_validation=$(echo "$chords" | jq -r '.validation.chord.description')
chords_section="## Chords"$'\n\n'"$chords_desc"$'\n\n'"- **Syntax**: \`$chords_syntax\`"$'\n'"- **Validation**: $chords_validation"$'\n'"- **Instructions**: $chords_inst"$'\n\n'"### Chord Attributes"$'\n\n'
while IFS= read -r attr; do
    name=$(echo "$attr" | jq -r '.name')
    desc=$(echo "$attr" | jq -r '.description')
    inst=$(echo "$attr" | jq -r '.instructions')
    example=$(echo "$attr" | jq -r '.example // "None"')
    validation=$(echo "$attr" | jq -r '.validation.description // "None"')
    
    chords_section+="#### \`$name\`"$'\n\n'
    chords_section+="*Description*: $desc"$'\n\n'
    chords_section+="*Instructions*: $inst"$'\n\n'
    chords_section+="*Example*: $example"$'\n\n'
    chords_section+="*Validation*: $validation"$'\n\n'
done < <(echo "$chords" | jq -c '.attributes[]')
cat << EOF > README.md
# Inline Chorded Lyrics Format (ICLF) Specification v$version

## Introduction
The Inline Chorded Lyrics Format (ICLF, pronounced "eye-see-el-ef") is a plain-text standard for notating song lyrics with inline chords. “Chorded” means lyrics are equipped with chords placed precisely at syllables or words, ensuring readability and musical accuracy.

ICLF is designed for:
- **Human Readability**: Musicians can open an ICLF file (\`.iclf\`) and play instantly.
- **Syllable-Precise Chords**: Chords like \`[Am]Parla\` align exactly with lyrics.
- **Extensibility**: Supports notes (\`#\` or non-reserved \`{key: value}\`) and custom directives via community proposals.
- **Cross-Platform Sharing**: Plain text ensures compatibility with any app or device.
- **Accessibility**: Screen-reader-friendly for all users.

ICLF is a secular, genre-agnostic format, unaffiliated with other organizations (e.g., International Christian Fellowship).

## Syntax
- **Chords**: \`[Chord]\` before a syllable/word (e.g., \`[Am]Parla\`).
- **Directives**: \`{key: value}\` for metadata or structure (e.g., \`{title: Song Name}\`).
- **Notes**:
  - \`# Comment\`: Freeform annotations (e.g., \`# Strum gently\`).
  - Non-reserved \`{key: value}\`: Custom notes (e.g., \`{mood: Romantic}\`).
- **Sections**: \`{section: Name}\` (e.g., \`{section: Verse}\`).

$directives_section

$chords_section

## Notes
Notes are annotations for performance tips, reminders, or custom metadata:
- **# Notes**: Simple comments prefixed with \`#\` (e.g., \`# Strum gently\`). Display as italicized text or in a dedicated UI section. Any text following \`#\` is valid (whitespace trimmed).
- **Non-Reserved Directives**: Any \`{key: value}\` not listed in [\`directives.json\`](./directives.json) (e.g., \`{practice: Arpeggiate softly}\`). Apps may display as text, balloons, or custom features.

## Extensibility
Non-reserved \`{key: value}\` notes can evolve into standard directives. Propose new directives at [github.com/yourusername/iclf-standard](https://github.com/yourusername/iclf-standard). Apps should treat unknown \`{key: value}\` as notes.

## Example
\`\`\`
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
\`\`\`

## Parsing
- **Load Directives**: Read \`directives.json\` to identify reserved \`{key: value}\`.
- **Chords**: Use regex \`\\\[([^\\]]+)\\\]([^\\[]+)\` to extract chord-text pairs.
- **Notes**: Store \`#\` comments and non-reserved \`{key: value}\` for display or app-specific features.
- **Validation**: Check \`{key: value}\` against \`validation\` rules in \`directives.json\`. Warn on invalid inputs.
- **Uniqueness**: Warn if unique directives (e.g., \`{title: ...}\`) appear multiple times.
- **Unknown Directives**: Treat as notes for forward compatibility.

## License
This specification is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## Contributing
Submit issues or pull requests at [github.com/yourusername/iclf-standard](https://github.com/yourusername/iclf-standard).
EOF

echo "README.md generated successfully!"