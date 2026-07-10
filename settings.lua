-- Pyanodon compatibility settings.
-- Only exposed when the Py mods that this compatibility layer targets are present,
-- so non-Py installs don't see irrelevant options.
if _G.mods["pyindustry"] and _G.mods["pyhightech"] then
    data:extend({
        {
            type = "bool-setting",
            name = "afhfp-reskin-pipe-to-grounds",
            setting_type = "startup",
            default_value = true
        },
        {
            type = "bool-setting",
            name = "afhfp-longer-undergrounds",
            setting_type = "startup",
            default_value = false
        }
    })
end
