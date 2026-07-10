-- Pyanodon compatibility (data-final-fixes stage).
-- Reskins the pipe-to-grounds to match Py's pipe graphics. Only runs when the
-- targeted Py mods are present and the reskin setting is enabled.
if _G.mods["pyindustry"] and _G.mods["pyhightech"] then
    require("prototypes.py-compat.data-final-fixes")
end
