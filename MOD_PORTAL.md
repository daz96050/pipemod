# Advanced Fluid Handling (forked)

A maintained, all-in-one fork of **Advanced Fluid Handling** that folds its companion mods
into a single package. Adds tiered underground pipe extensions, junctions, rotatable
pipes-to-ground, underground pumps, and valves — with optional Pyanodon and simplified-recipe
modes built right in.

## Replaces these mods

This mod merges the features of the following into one, so you only need this:

- **Advanced Fluid Handling**
- **Advanced Fluid Handling For PyMods**
- **Advanced Fluid Handling (simple)**
- **Less Advanced Fluid Handling**
- **Advanced Fluid Handling Casting**

You do **not** need any of the above installed alongside this — everything is included and
toggled automatically or via startup settings. Remove them to avoid conflicts.

## Features

- **Underground pipe extensions** — I, L, T, and Cross shaped underground pipe pieces.
- **Rotatable pipes-to-ground** — pipes-to-ground with I, L, T, and Cross underground outputs
  whose underground port rotates independently of the above-ground port. Press **CTRL + R**
  to rotate the underground port(s).
- **Multi-connection pipes** — 1→2, 1→3, and 1→4 surface-to-underground junctions in several
  orientations.
- **3 tiers of underground pump** — colour-coded so they're easy to tell apart in your
  inventory and on recipe pages.
- **Valves** — overflow, top-up, and check valves using the modern valve prototype.

## Optional: Pyanodon integration (automatic)

When **pyindustry** and **pyhightech** are present, the mod automatically retunes itself for
Pyanodon — no extra download:

- Recipes, underground distances, and pipeline extents adjusted to match Py pipes.
- Compatible with Py's braided pipes (tier-matched connection categories).
- Underground pumps rebalanced to the vanilla pump.
- Tiers renamed to **Iron / Niobium / Multipurpose**.
- Removes the 4-to-4 pipe; valve flow rates doubled.

Startup settings (shown only when the Py mods are active):

- **Reskin pipe-to-grounds** to match Pyanodon pipe graphics *(on by default)*.
- **Make undergrounds longer by one tile** to match vanilla AFH distances *(off by default)*.

Installs without Pyanodon are completely unaffected.

## Optional: Simplified recipes (startup setting)

Enable **"Simplified recipes"** to flatten pipe/pump/valve recipes down to their base
materials and hide the intermediate items (couplers, pipe segments, swivel joint):

- Base pipes need only iron.
- Higher tiers use their own tier material automatically — e.g. **niobium for niobium pipes**
  under Pyanodon. Without Py: base/T2 use iron, T3 uses iron + steel.
- Adds **Foundry casting recipes** when Space Age's foundry is available.

> ⚠️ While this setting is on, the intermediate items are hidden and disabled — existing
> blueprints or production lines that build or use them will break.

## Compatibility

- Factorio **2.1+**.
- Optional support for Space Exploration, Space Age, Dectorio, and Bob's Logistics.
- `no-pipe-touching` supported.

## Credits

Built on the work of the original authors:

- **Advanced Fluid Handling** — TheStaplergun
- **Advanced Fluid Handling For PyMods** — Dremon (created by Sopel)
- **Advanced Fluid Handling (simple)** — billbo99
- **Less Advanced Fluid Handling** — harag
- **Advanced Fluid Handling Casting** — GM.STEELDRAGON

Fork maintained by daz96050.
