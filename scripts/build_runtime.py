#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
COMMAND_DIR = ROOT / 'src' / 'command'
PERSONA_DIR = ROOT / 'src' / 'prompts' / 'personas'
MODULE_DIR = ROOT / 'src' / 'prompts' / 'modules'
TEMPLATE_DIR = ROOT / 'src' / 'prompts' / 'templates'
OUTPUT_PATH = ROOT / 'khon-v1' / 'commands' / 'khon-party.md'

REQUIRED_COMMAND_FILES = [
    '00-frontmatter.md',
    '10-role-and-overview.md',
    '20-preflight.md',
    '30-objective-inference.md',
    '40-override-parsing.md',
    '50-persona-selection.md',
    '60-module-selection.md',
    '70-debate-process.md',
    '80-governance-gate.md',
    '90-final-synthesis.md',
    '95-output-contract.md',
    '99-llm-notes.md',
]

REQUIRED_MODULE_FILES = [
    'cog.role_playing.md',
    'cog.six_thinking_hats.md',
    'cog.second_order_observation.md',
    'cog.black_swan.md',
    'cog.consequences.md',
    'cog.swot.md',
    'cog.swiss_cheese.md',
    'cog.starbursting.md',
    'cog.five_whys.md',
    'cog.scamper.md',
    'cog.mind_mapping.md',
    'cog.reverse_brainstorming.md',
    'cog.face_it.md',
    'cog.pareto.md',
    'cog.eisenhower.md',
    'cog.friend_request_trust.md',
    'cog.making_of.md',
    'cog.double_loop_learning.md',
    'cog.result_optimisation.md',
    'cog.monte_carlo.md',
    'cog.conflict_resolution.md',
]

MODULE_FIELD_RE = re.compile(r'^-\s+([a-z_]+):\s+`?(.*?)`?\s*$')


def read_file(path: Path) -> str:
    if not path.exists():
        raise FileNotFoundError(f'Missing required file: {path}')
    return path.read_text(encoding='utf-8').rstrip() + '\n'


def collect_sorted(directory: Path) -> list[Path]:
    if not directory.exists():
        raise FileNotFoundError(f'Missing required directory: {directory}')
    files = sorted(directory.glob('*.md'))
    if not files:
        raise FileNotFoundError(f'No markdown files found in: {directory}')
    return files


def parse_module_summary(text: str) -> dict[str, str]:
    data: dict[str, str] = {}
    for line in text.splitlines():
        match = MODULE_FIELD_RE.match(line.strip())
        if match:
            key, value = match.groups()
            data[key] = value
    required = ['id', 'name', 'category', 'best_for', 'round_bias', 'avoid_when']
    missing = [key for key in required if not data.get(key)]
    if missing:
        raise ValueError(f'Module card missing required summary fields {missing}')
    return data


def build_module_catalog_summary(module_texts: list[str]) -> list[str]:
    rows = [parse_module_summary(text) for text in module_texts]
    lines = [
        '## Generated Module Catalog Summary',
        '',
        'Use this as the quick index for module selection before consulting the full module cards.',
        '',
        '| Module | Category | Best for | Round bias | Avoid when |',
        '|---|---|---|---|---|',
    ]
    for row in rows:
        lines.append(
            f"| `{row['id']}` | `{row['category']}` | {row['best_for']} | {row['round_bias']} | {row['avoid_when']} |"
        )
    lines.append('')
    return lines


def main() -> int:
    command_paths = [COMMAND_DIR / name for name in REQUIRED_COMMAND_FILES]
    for module_name in REQUIRED_MODULE_FILES:
        if not (MODULE_DIR / module_name).exists():
            raise FileNotFoundError(f'Missing required module prompt: {MODULE_DIR / module_name}')

    frontmatter = read_file(command_paths[0]).rstrip()
    body_sections = [read_file(path).rstrip() for path in command_paths[1:]]
    persona_sections = [read_file(path).rstrip() for path in collect_sorted(PERSONA_DIR)]
    module_sections = [read_file(path).rstrip() for path in collect_sorted(MODULE_DIR)]
    template_sections = [read_file(path).rstrip() for path in collect_sorted(TEMPLATE_DIR)]
    module_catalog_summary = build_module_catalog_summary(module_sections)

    parts: list[str] = [
        frontmatter,
        '',
        '<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT khon-v1/commands/khon-party.md DIRECTLY. -->',
        '<!-- Edit src/ and rerun: python3 scripts/build_runtime.py -->',
        '',
    ]

    for section in body_sections:
        parts.extend([section, ''])

    parts.extend([
        '## Embedded Persona Cards',
        '',
        'Use these cards as the persona library for roster selection and debate behavior.',
        'Do not dump them verbatim to the user unless explicitly asked.',
        '',
    ])
    for section in persona_sections:
        parts.extend([section, ''])

    parts.extend(module_catalog_summary)

    parts.extend([
        '## Embedded Cognitive Module Cards',
        '',
        'These cards preserve the curated KHON module methodologies and khon-party-specific application notes.',
        'When a module is selected, apply its methodology, analysis protocol, and application notes as reasoning constraints.',
        '',
    ])
    for section in module_sections:
        parts.extend([section, ''])

    parts.extend([
        '## Embedded Debate Templates',
        '',
        'Use these as reusable scaffolds for running the visible debate and synthesis.',
        '',
    ])
    for section in template_sections:
        parts.extend([section, ''])

    output = '\n'.join(parts).rstrip() + '\n'
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(output, encoding='utf-8')

    print(f'Built runtime: {OUTPUT_PATH}')
    print(f'Embedded personas: {len(persona_sections)}')
    print(f'Embedded modules: {len(module_sections)}')
    print(f'Embedded templates: {len(template_sections)}')
    return 0


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f'Build failed: {exc}', file=sys.stderr)
        raise SystemExit(1)
