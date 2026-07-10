-- Pyanodon compatibility (data-updates stage).
-- Adjusts recipes, underground distances, braided-pipe categories, pump specs,
-- tech prerequisites and valve flow rates to fit the Py mods. Only runs when the
-- targeted Py mods are present, so a normal (non-Py) install is untouched.
if _G.mods["pyindustry"] and _G.mods["pyhightech"] then
    require("prototypes.py-compat.data-updates")
end
