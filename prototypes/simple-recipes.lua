-- Simplified recipes (optional).
-- Ported from the standalone "Advanced Fluid Handling (simple)" addon (billbo99).
-- Recursively flattens each pipe/pump/valve recipe down to its base materials
-- (expanding intermediates such as couplers and pipe segments), then hides the
-- now-unneeded intermediate recipes. Also adds Foundry casting recipes when the
-- Space Age foundry tech is present.
--
-- This runs AFTER the Py-compat data-updates, so when Py is active the flattened
-- recipes inherit Py's tier materials automatically (e.g. niobium plates end up in
-- the niobium-tier pipes) without any tier-specific hardcoding here.

local variants = {
    "one-to-one-forward",
    "one-to-two-perpendicular",
    "one-to-three-forward",
    "one-to-four",
    "underground-i",
    "underground-L",
    "underground-t",
    "underground-cross",
}

local tiers = {
    {
        coupler = "small-pipe-coupler",
        segment = "underground-pipe-segment-t1",
        pump = "underground-mini-pump",
        suffix = "",
    },
    {
        coupler = "medium-pipe-coupler",
        segment = "underground-pipe-segment-t2",
        pump = "underground-mini-pump-t2",
        suffix = "-t2",
    },
    {
        coupler = "large-pipe-coupler",
        segment = "underground-pipe-segment-t3",
        pump = "underground-mini-pump-t3",
        suffix = "-t3",
    },
}

if mods['space-exploration'] then
    table.insert(
        tiers,
        {
            coupler = "space-pipe-coupler",
            segment = "underground-pipe-segment-space",
            suffix = "-space",
        }
    )
end

local CACHE = {}
local METALLURGY = {}
local RECIPE_BY_TECH = {}

local function cache_tech()
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for _, effect in pairs(tech.effects) do
                if effect.type == "unlock-recipe" then
                    if not (RECIPE_BY_TECH[effect.recipe]) then
                        RECIPE_BY_TECH[effect.recipe] = {}
                    end
                    table.insert(RECIPE_BY_TECH[effect.recipe], tech.name)
                end
            end
        end
    end
end

local function cache_metallurgy()
    for recipe_name, recipe in pairs(data.raw["recipe"]) do
        if recipe.category == 'metallurgy' then
            if recipe.results[1].type == 'item' and #recipe.ingredients == 1 and #recipe.results == 1 then
                local _fluid_name = recipe.ingredients[1].name
                local _fluid_amount = recipe.ingredients[1].amount
                local _item_name = recipe.results[1].name
                local _item_amount = recipe.results[1].amount
                METALLURGY[_item_name] = {
                    fluid_name = _fluid_name,
                    fluid_amount = _fluid_amount / _item_amount
                }
            end
        end
    end
end

local function update_cache(recipe_name, item_name, item_amount, item_type)
    if not CACHE[recipe_name] then
        CACHE[recipe_name] = {}
    end

    if CACHE[item_name] then
        for k, v in pairs(CACHE[item_name]) do
            if CACHE[recipe_name][k] then
                CACHE[recipe_name][k].amount = CACHE[recipe_name][k].amount + (v.amount * item_amount)
            else
                CACHE[recipe_name][k] = { amount = v.amount * item_amount, type = v.type }
            end
        end
    else
        if CACHE[recipe_name][item_name] then
            CACHE[recipe_name][item_name].amount = CACHE[recipe_name][item_name].amount + item_amount
        else
            CACHE[recipe_name][item_name] = { amount = item_amount, type = item_type }
        end
    end
end

local function add_casting_recipe(recipe)
    if data.raw.technology['foundry'] == nil then return end

    if data.raw.recipe['casting-' .. recipe.name] then return end
    -- 10 molten iron = 1 pipe
    -- 20 molten iron = 2 iron plate
    -- 30 molten iron = 1 steel plate
    local new_ingredients = {}
    local fluid_ingredients = {}
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.type == 'item' and METALLURGY[ingredient.name] then
            local ingredient_count = ingredient.amount
            local fluid_name = METALLURGY[ingredient.name].fluid_name
            local fluid_amount = METALLURGY[ingredient.name].fluid_amount * ingredient_count
            if fluid_ingredients[fluid_name] == nil then
                fluid_ingredients[fluid_name] = 0
            end
            fluid_ingredients[fluid_name] = fluid_ingredients[fluid_name] + fluid_amount
        else
            table.insert(new_ingredients, ingredient)
        end
    end
    for fluid_name, fluid_amount in pairs(fluid_ingredients) do
        local _new_ingredient = {
            name = fluid_name,
            amount = fluid_amount,
            type = 'fluid'
        }
        table.insert(new_ingredients, _new_ingredient)
    end

    local new_order
    if recipe.order then
        new_order = "b[casting]-f[" .. recipe.order .. "]"
    elseif data.raw.item[recipe.name] and data.raw.item[recipe.name].order then
        local _order = data.raw.item[recipe.name].order
        local _subgroup = data.raw.item[recipe.name].subgroup
        if _subgroup == 'pipes-to-ground' then _subgroup = 'pipes-to-ground-t1' end
        if _subgroup == 'underground-pipes' then _subgroup = 'underground-pipes-t1' end
        new_order = "b[casting]-f[" .. _subgroup .. "][" .. _order .. "]"
    else
        new_order = "b[casting]-f[" .. recipe.name .. "]"
    end

    local result1 = recipe.results[1]
    local new_icon
    if recipe.icon then
        new_icon = recipe.icon
    elseif data.raw[result1.type][result1.name].icon then
        new_icon = data.raw[result1.type][result1.name].icon
    end

    local new_icon_size = 64
    if recipe.icon_size then
        new_icon_size = recipe.icon_size
    elseif data.raw[result1.type][result1.name].icon_size then
        new_icon_size = data.raw[result1.type][result1.name].icon_size
    end

    local casting_recipe = {
        type = "recipe",
        name = 'casting-' .. recipe.name,
        category = "metallurgy",
        subgroup = recipe.subgroup,
        order = new_order,
        localised_name = { 'entity-name.' .. recipe.name },
        localised_description = { 'recipe-description.' .. recipe.name },
        icons = {
            { icon = new_icon,                                             icon_size = new_icon_size },
            { icon = "__space-age__/graphics/icons/fluid/molten-iron.png", scale = 0.25,             shift = { 12, 12 } },
        },
        enabled = false,
        ingredients = new_ingredients,
        energy_required = 1,
        allow_decomposition = false,
        results = { { type = "item", name = recipe.results[1].name, amount = recipe.results[1].amount } },
        allow_productivity = false
    }
    data:extend({ casting_recipe })

    local tech = data.raw.technology['cast-advanced-underground-piping']
    if tech then
        table.insert(tech.effects, { type = "unlock-recipe", recipe = casting_recipe.name })
    end
end

local function add_tech()
    if data.raw.technology['foundry'] == nil then return end

    local tech = table.deepcopy(data.raw.technology['foundry'])
    tech.name = 'cast-advanced-underground-piping'
    tech.effects = {}
    tech.prerequisites = { 'foundry' }
    tech.research_trigger = nil
    tech.unit = {
        count = 500,
        ingredients =
        {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "space-science-pack",       1 },
            { "metallurgic-science-pack", 1 }
        },
        time = 30
    }
    tech.icon_size = 128
    tech.icons = {
        { icon = '__advanced-fluid-handling-forked__/graphics/technology/advanced-underground-piping-t1.png', scale = 0.5,  icon_size = 128, shift = { -32, -32 } },
        { icon = '__advanced-fluid-handling-forked__/graphics/technology/advanced-underground-piping-t2.png', scale = 0.5,  icon_size = 128, shift = { 32, -32 } },
        { icon = '__advanced-fluid-handling-forked__/graphics/technology/advanced-underground-piping-t3.png', scale = 0.5,  icon_size = 128, shift = { -32, 32 } },
        { icon = '__space-age__/graphics/technology/foundry.png',                                             scale = 0.25, icon_size = 256, shift = { 32, 32 } },
    }
    data:extend({ tech })
end


local function process_recipe(recipe_name, remove_tech, create_casting)
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        for _, ingredient in pairs(recipe.ingredients) do
            local item = ingredient.name
            local amount = ingredient.amount
            local item_type = ingredient.type
            update_cache(recipe_name, item, amount, item_type)
        end

        local ingredients = {}
        for k, v in pairs(CACHE[recipe_name]) do
            if CACHE[k] then
                for k2, v2 in pairs(CACHE[k]) do
                    table.insert(ingredients, { name = k2, amount = v2.amount * v.amount, type = v2.type })
                end
            else
                table.insert(ingredients, { name = k, amount = v.amount, type = v.type })
            end
        end
        data.raw.recipe[recipe_name].ingredients = ingredients

        if create_casting then add_casting_recipe(recipe) end

        if remove_tech then
            if RECIPE_BY_TECH[recipe_name] then
                for _, tech_name in pairs(RECIPE_BY_TECH[recipe_name]) do
                    local tech = data.raw.technology[tech_name]
                    local effects = {}
                    for _, effect in pairs(tech.effects) do
                        if effect.type == "unlock-recipe" and effect.recipe ~= recipe_name then
                            table.insert(effects, effect)
                        elseif effect.type ~= "unlock-recipe" then
                            table.insert(effects, effect)
                        end
                    end
                    tech.effects = effects
                end
            end
            data.raw.recipe[recipe_name].hidden = true
            data.raw.recipe[recipe_name].enabled = false
        end
    end
end

add_tech()
cache_tech()
cache_metallurgy()

process_recipe("pipe", nil, false)
if mods['space-exploration'] then
    process_recipe("se-space-pipe", nil, false)
    process_recipe("se-heavy-girder", nil, false)
end

process_recipe("iron-gear-wheel", nil, false)

for _, tier in pairs(tiers) do
    process_recipe(tier.coupler, true, false)
    process_recipe(tier.segment, true, false)
    process_recipe(tier.pump, false, false)
end

process_recipe("swivel-joint", true, false)
process_recipe("80-overflow-valve", false, true)
process_recipe("80-top-up-valve", false, true)
process_recipe("check-valve", false, true)
process_recipe("4-to-4-pipe", false, true)

for _, tier in pairs(tiers) do
    for _, variant in pairs(variants) do
        process_recipe(variant .. tier.suffix .. "-pipe", nil, true)
    end
end
