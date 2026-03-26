#!/usr/bin/env python3
from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
COMMAND_DIR = ROOT / 'src' / 'command'
PERSONA_DIR = ROOT / 'src' / 'prompts' / 'personas'
MODULE_DIR = ROOT / 'src' / 'prompts' / 'modules'
TEMPLATE_DIR = ROOT / 'src' / 'prompts' / 'templates'
BASE_OUTPUT_PATH = ROOT / 'khon-v1' / 'commands' / 'khon-party.md'
MARKETPLACE_PATH = ROOT / '.claude-plugin' / 'marketplace.json'
PLUGIN_DIR = ROOT / 'plugins' / 'khon-party'
PLUGIN_MANIFEST_PATH = PLUGIN_DIR / '.claude-plugin' / 'plugin.json'
MORE_SKILL_PATH = PLUGIN_DIR / 'skills' / 'more' / 'SKILL.md'
MAX_SKILL_PATH = PLUGIN_DIR / 'skills' / 'max' / 'SKILL.md'

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


@dataclass(frozen=True)
class RuntimeProfile:
    key: str
    command_name: str
    description: str
    argument_hint: str
    output_path: Path
    generated_path_label: str
    fixed_mode_label: str
    mode_behavior: str
    conflict_rule: str
    compatibility_note: str


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


def parse_frontmatter(text: str) -> dict[str, str]:
    lines = text.strip().splitlines()
    if len(lines) < 3 or lines[0].strip() != '---' or lines[-1].strip() != '---':
        raise ValueError('Frontmatter file must start and end with --- markers')

    data: dict[str, str] = {}
    for line in lines[1:-1]:
        stripped = line.strip()
        if not stripped:
            continue
        key, sep, value = stripped.partition(':')
        if not sep:
            raise ValueError(f'Invalid frontmatter line: {line}')
        data[key.strip()] = value.strip().strip('"').strip("'")
    return data


def build_frontmatter(items: list[tuple[str, str | bool]]) -> str:
    lines = ['---']
    for key, value in items:
        if isinstance(value, bool):
            rendered = 'true' if value else 'false'
        else:
            rendered = json.dumps(value, ensure_ascii=False)
        lines.append(f'{key}: {rendered}')
    lines.append('---')
    return '\n'.join(lines)


def strip_inline_mode_tokens(argument_hint: str) -> str:
    cleaned = argument_hint.replace('[:more]', '').replace('[:max]', '')
    cleaned = re.sub(r'\s+', ' ', cleaned).strip()
    return cleaned


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


def build_shared_core(
    body_sections: list[str],
    persona_sections: list[str],
    module_sections: list[str],
    template_sections: list[str],
) -> list[str]:
    module_catalog_summary = build_module_catalog_summary(module_sections)
    parts: list[str] = []

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

    return parts


def build_runtime_entry(profile: RuntimeProfile, shared_core: list[str]) -> str:
    parts: list[str] = [
        build_frontmatter([
            ('description', profile.description),
            ('argument-hint', profile.argument_hint),
            ('user-invocable', True),
        ]),
        '',
        f'<!-- GENERATED FROM SOURCE FILES. DO NOT EDIT {profile.generated_path_label} DIRECTLY. -->',
        '<!-- Edit src/ and rerun: python3 scripts/build_runtime.py -->',
        '',
        '## Runtime Entry Point',
        '',
        f'- canonical command: `{profile.command_name}`',
        f'- fixed mode: {profile.fixed_mode_label}',
        '- shared core: this entrypoint is generated from the same source tree as `/khon-party`, `/khon-party:more`, and `/khon-party:max`.',
        f'- mode behavior: {profile.mode_behavior}',
        f'- conflict rule: {profile.conflict_rule}',
        f'- compatibility note: {profile.compatibility_note}',
        '',
    ]
    parts.extend(shared_core)
    return '\n'.join(parts).rstrip() + '\n'


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def main() -> int:
    command_paths = [COMMAND_DIR / name for name in REQUIRED_COMMAND_FILES]
    for module_name in REQUIRED_MODULE_FILES:
        if not (MODULE_DIR / module_name).exists():
            raise FileNotFoundError(f'Missing required module prompt: {MODULE_DIR / module_name}')

    source_frontmatter = parse_frontmatter(read_file(command_paths[0]).rstrip())
    base_description = source_frontmatter.get('description')
    base_argument_hint = source_frontmatter.get('argument-hint')
    if not base_description or not base_argument_hint:
        raise ValueError('Frontmatter must include description and argument-hint')

    body_sections = [read_file(path).rstrip() for path in command_paths[1:]]
    persona_sections = [read_file(path).rstrip() for path in collect_sorted(PERSONA_DIR)]
    module_sections = [read_file(path).rstrip() for path in collect_sorted(MODULE_DIR)]
    template_sections = [read_file(path).rstrip() for path in collect_sorted(TEMPLATE_DIR)]
    shared_core = build_shared_core(body_sections, persona_sections, module_sections, template_sections)
    namespaced_argument_hint = strip_inline_mode_tokens(base_argument_hint)

    profiles = [
        RuntimeProfile(
            key='base',
            command_name='/khon-party',
            description=base_description,
            argument_hint=base_argument_hint,
            output_path=BASE_OUTPUT_PATH,
            generated_path_label='khon-v1/commands/khon-party.md',
            fixed_mode_label='balanced default',
            mode_behavior='Run the normal balanced mode by default. Inline `[:more]` and `[:max]` remain supported here for back-compat when the namespaced plugin commands are not being used.',
            conflict_rule='Respect explicit inline `[:more]` or `[:max]` when the user invokes the base command directly.',
            compatibility_note='Use `/khon-party` for the default experience; prefer `/khon-party:more` and `/khon-party:max` as the canonical expansion entrypoints when the plugin is installed.',
        ),
        RuntimeProfile(
            key='more',
            command_name='/khon-party:more',
            description='Expanded brainstorm-then-debate mode with broader ideation and stronger debate pressure, generated from the same KHON Party core runtime.',
            argument_hint=namespaced_argument_hint,
            output_path=MORE_SKILL_PATH,
            generated_path_label='plugins/khon-party/skills/more/SKILL.md',
            fixed_mode_label='`:more`',
            mode_behavior='Treat this entrypoint exactly as if the user explicitly supplied `[:more]` before any other argument parsing begins.',
            conflict_rule='Ignore conflicting inline mode tokens and keep this entrypoint locked to `:more`; still honor other inline overrides such as personas, modules, depth, style, focus, and help.',
            compatibility_note='This is the canonical expanded-selective entrypoint; users should prefer `/khon-party:more` over typing `[:more]` on the base command.',
        ),
        RuntimeProfile(
            key='max',
            command_name='/khon-party:max',
            description='Maximum KHON Party mode with all 21 modules, a larger panel when useful, and the longest debate scale, generated from the same shared core runtime.',
            argument_hint=namespaced_argument_hint,
            output_path=MAX_SKILL_PATH,
            generated_path_label='plugins/khon-party/skills/max/SKILL.md',
            fixed_mode_label='`:max`',
            mode_behavior='Treat this entrypoint exactly as if the user explicitly supplied `[:max]` before any other argument parsing begins.',
            conflict_rule='Ignore conflicting inline mode tokens and keep this entrypoint locked to `:max`; still honor other inline overrides such as personas, modules, depth, style, focus, and help.',
            compatibility_note='This is the canonical strongest entrypoint; users should prefer `/khon-party:max` over typing `[:max]` on the base command.',
        ),
    ]

    for profile in profiles:
        output = build_runtime_entry(profile, shared_core)
        profile.output_path.parent.mkdir(parents=True, exist_ok=True)
        profile.output_path.write_text(output, encoding='utf-8')

    write_json(
        PLUGIN_MANIFEST_PATH,
        {
            'name': 'khon-party',
            'description': 'Namespaced KHON Party command family for Claude Code',
            'version': '1.0.0',
            'author': {
                'name': 'Issaret Prachitmutita',
                'email': 'imac.monochrome@gmail.com',
            },
        },
    )

    write_json(
        MARKETPLACE_PATH,
        {
            'name': 'khon-party',
            'owner': {
                'name': 'Issaret Prachitmutita',
                'email': 'imac.monochrome@gmail.com',
            },
            'metadata': {
                'description': 'KHON Party marketplace metadata for the namespaced Claude Code plugin variants.',
            },
            'plugins': [
                {
                    'name': 'khon-party',
                    'source': './plugins/khon-party',
                    'description': 'Adds /khon-party:more and /khon-party:max from the shared KHON Party runtime.',
                }
            ],
        },
    )

    print(f'Built runtime: {BASE_OUTPUT_PATH}')
    print(f'Built plugin skill: {MORE_SKILL_PATH}')
    print(f'Built plugin skill: {MAX_SKILL_PATH}')
    print(f'Built plugin manifest: {PLUGIN_MANIFEST_PATH}')
    print(f'Built marketplace metadata: {MARKETPLACE_PATH}')
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
