-- Configurable Valves compatibility.
-- Configurable Valves provides valves whose direction and threshold are adjustable at
-- runtime, which supersedes this mod's fixed overflow / top-up / check valves. When it is
-- present (and the setting is on) we retire our valve recipes so the two don't overlap.
-- The valve ENTITIES are left intact, so existing placed valves and blueprints keep
-- working - you just can't craft new ones from this mod.
local valves = {"80-overflow-valve", "80-top-up-valve", "check-valve"}

-- Names to retire: the base recipes plus any Foundry "casting-" variants that the
-- simplified-recipes pass may have created (this file runs after it).
local retired = {}
for _, n in pairs(valves) do
    retired[n] = true
    retired["casting-" .. n] = true
end

-- Disable and hide the recipes.
for name in pairs(retired) do
    local recipe = data.raw.recipe[name]
    if recipe then
        recipe.enabled = false
        recipe.hidden = true
    end
end

-- Strip the unlock-recipe effects for those recipes from every technology.
for _, tech in pairs(data.raw.technology) do
    if tech.effects then
        local kept = {}
        for _, effect in pairs(tech.effects) do
            if not (effect.type == "unlock-recipe" and retired[effect.recipe]) then
                kept[#kept + 1] = effect
            end
        end
        tech.effects = kept
    end
end

-- Hide the items so they don't clutter menus (placed entities still function).
for _, n in pairs(valves) do
    local item = data.raw.item[n]
    if item then
        item.hidden = true
    end
end
