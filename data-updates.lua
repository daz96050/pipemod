-- Pyanodon compatibility (data-updates stage).
-- Adjusts recipes, underground distances, braided-pipe categories, pump specs,
-- tech prerequisites and valve flow rates to fit the Py mods. Only runs when the
-- targeted Py mods are present, so a normal (non-Py) install is untouched.
if _G.mods["pyindustry"] and _G.mods["pyhightech"] then
    require("prototypes.py-compat.data-updates")
end

-- Simplified recipes (optional). Must run AFTER Py-compat so that flattening the
-- recipe tree picks up Py's tier materials (e.g. niobium for niobium pipes).
if settings.startup["afh-simple-recipes"].value then
    require("prototypes.simple-recipes")
end

-- Configurable Valves compatibility. Runs LAST so it also retires any valve casting
-- variants that the simplified-recipes pass may have created.
if _G.mods["configurable-valves"]
    and settings.startup["afh-defer-valves-to-configurable-valves"].value then
    require("prototypes.valve-compat")
end
