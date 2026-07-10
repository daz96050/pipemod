# CLAUDE.md — Advanced Fluid Handling (forked)

A Factorio 2.x mod (fork of TheStaplergun's "Advanced Fluid Handling" / `underground-pipe-pack`).
Adds tiered underground pipe extensions, pipes-to-ground with rotatable underground ports
(I/L/T/Cross shapes), underground pumps, and valves.

## Critical: mod name vs. graphics paths

In Factorio, the `__modname__` prefix in any asset path resolves to the **internal `name`
field in `info.json`** — NOT the folder or display title. This mod's internal name is
`advanced-fluid-handling-forked`.

- Every graphics/icon path in the Lua must use `__advanced-fluid-handling-forked__/...`.
- If you ever change `name` in info.json, you MUST update every `__...__` path prefix to
  match, or the game fails to load with: *"Path __X__/... does not match any enabled mod."*
- Prefer changing `title` (display name) instead of `name` to avoid this entirely.

## Layout & load stages

- `info.json` — internal name, version, dependencies. Version uses the fork scheme `0.0.x`
  (the changelog still carries upstream `2.0.x` entries — a known inconsistency; Factorio's
  in-game changelog matches against info.json's version, so keep a matching top entry).
- `settings.lua` — startup settings (settings stage). The `mods` table IS available here.
- `data.lua` — main data stage; `require`s everything under `prototypes/`.
- `data-updates.lua` / `data-final-fixes.lua` — later data stages (used by Py compat).
- `prototypes/` — entities, items, recipes, technology, groups, controls.
- `tables.lua` — rotation/blueprint-correction lookup tables for the multi-pipe variants.
- `locale/en/en.cfg` — names/descriptions.
- `control.lua` / `scripts/` — runtime scripts.
- `deploy.ps1` — packaging/deploy helper.

### Prototype facts worth remembering
- The underground extension pipes (`underground-i/L/t/cross-*`) are type **`pipe-to-ground`**
  (deep-copied from base `pipe-to-ground`), not type `pipe`.
- A `pipe-to-ground`'s `.pictures` table is keyed **`north/south/west/east`** (mapped to
  the `-up/-down/-left/-right` PNG files).
- Underground pumps are type `pump`, use `.icon` + `.icon_size` (not `.icons`), and have
  directional `.animations` each with a `.layers` array; arrow layers have `hr-ug-arrow`
  in the filename.

## Pyanodon compatibility (optional, built-in)

Integrated from the standalone "Advanced Fluid Handling For PyMods" addon so no separate
download is needed. All Py logic is gated on `_G.mods["pyindustry"] and _G.mods["pyhightech"]`
— non-Py installs are completely unaffected.

- Entry points: `settings.lua`, `data-updates.lua`, `data-final-fixes.lua` each check the
  gate, then the two data files `require("prototypes.py-compat.*")`.
- `prototypes/py-compat/data-updates.lua` — retunes recipes, underground distances/extents,
  braided-pipe `connection_category`, pump specs, tech prerequisites; doubles valve flow;
  removes the 4-to-4 pipe; applies Iron/Niobium/Multipurpose naming.
- `prototypes/py-compat/data-final-fixes.lua` — reskins pipe-to-grounds to match Py pipes.
- Depends on Py prototypes existing (`niobium-pipe-to-ground`, `ht-pipes-to-ground`,
  `niobium-plate`, `niobium` / `coal-processing-3` techs, the `py-braided-pipes` setting) —
  all safe because the gate guarantees Py is loaded.

### Conditional locale pattern
Factorio loads ALL `.cfg` files unconditionally — you cannot ship alternate locale that
only applies under another mod. So Py's renaming lives under dedicated key sections in
`en.cfg` (`[py-afh-entity-name]`, `[py-afh-item-name]`, `[py-afh-technology-name]`, etc.)
and is applied by setting `localised_name` / `localised_description` on prototypes at the
data stage, only when the Py gate passes. This is the general technique for any
mod-conditional locale here.

### Known faithful quirk (do not "fix" silently)
In the Py reskin, `variants` is keyed `north/south/west/east` but `tiers[].shifts` is keyed
`up/down/left/right`, so `shifts[dir]` resolves to `nil` (→ no shift). Factorio tolerates
`shift = nil`. This matches the original addon's behavior exactly; the tier-3 arrow shift
never actually applies. Kept intentionally for fidelity.

## Dev workflow / tooling

- **Lua interpreter for syntax checks:** `winget install DEVCOM.Lua` (Lua 5.4). Then
  `luac -p <file.lua>` parse-checks a file. Note Factorio uses Lua **5.2**; 5.4 is fine for
  syntax but not an exact runtime match.
- **IDE lint noise:** the Lua language server flags `data`, `mods`, `settings`, `util` as
  "undefined global/field". These are Factorio engine globals — **false positives**, expected
  throughout the codebase. The `_G.mods[...]` idiom (see `data.lua`) is used to keep the
  gating checks a bit quieter, matching existing style.
- No unit-test harness; verification = loading the mod in Factorio (ideally with the Py mods
  enabled to exercise the compat path).
- `*.zip` and `.idea` are gitignored; packaged mod zips live in the repo root.
