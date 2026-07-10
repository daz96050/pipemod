-- Simplified recipes (optional, works with or without Py).
-- Flattens pipe recipes to their base materials and hides the intermediate items.
data:extend({
    {
        type = "bool-setting",
        name = "afh-simple-recipes",
        setting_type = "startup",
        default_value = false,
        order = "a"
    }
})

-- Configurable Valves compatibility (only shown when that mod is present).
-- When on, this mod's fixed valves are retired in favor of Configurable Valves'
-- adjustable ones.
if _G.mods["configurable-valves"] then
    data:extend({
        {
            type = "bool-setting",
            name = "afh-defer-valves-to-configurable-valves",
            setting_type = "startup",
            default_value = true,
            order = "b"
        }
    })
end

-- Pyanodon compatibility settings.
-- Only exposed when the Py mods that this compatibility layer targets are present,
-- so non-Py installs don't see irrelevant options.
if _G.mods["pyindustry"] and _G.mods["pyhightech"] then
    data:extend({
        {
            type = "bool-setting",
            name = "afhfp-reskin-pipe-to-grounds",
            setting_type = "startup",
            -- On by default: the Py-styled placed pipes look better. Note this only reskins
            -- the placed entity, not the item/tech icon, so those don't match the placed pipe.
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
