-- Pyanodon compatibility - data-updates stage.
-- Ported from the standalone "Advanced Fluid Handling For PyMods" addon
-- (Dremon, created by Sopel) so it ships built-in as an optional integration.
-- This file is only required when pyindustry + pyhightech are present.
do
    local braided = settings.startup["py-braided-pipes"] and settings.startup["py-braided-pipes"].value

    local blacklist = {
        ["4-to-4-pipe"] = true,
    }

    for k, v in pairs(data.raw.item) do
        if blacklist[k] then
            data.raw.item[k] = nil
        end
    end

    for k, v in pairs(data.raw["pipe"]) do
        if blacklist[k] then
            data.raw["pipe"][k] = nil
        end
    end

    for k, v in pairs(data.raw["pipe-to-ground"]) do
        if blacklist[k] then
            data.raw["pipe-to-ground"][k] = nil
        end
    end

    for k, v in pairs(data.raw["storage-tank"]) do
        if blacklist[k] then
            data.raw["storage-tank"][k] = nil
        end
    end

    for k, v in pairs(data.raw.recipe) do
        if blacklist[k] then
            data.raw.recipe[k] = nil
        end
    end

    for kt, vt in pairs(data.raw.technology) do
        if vt.effects ~= nil then
            for k, v in ipairs(vt.effects) do
                if v.type == "unlock-recipe" and blacklist[v.recipe] then
                    vt.effects[k] = nil
                end
            end
        end
    end

    local t1_underground_pipes = {
        "one-to-one-forward-pipe",
        "one-to-one-left-pipe",
        "one-to-one-reverse-pipe",
        "one-to-one-right-pipe",
        "one-to-two-perpendicular-pipe",
        "one-to-two-parallel-pipe",
        "one-to-two-perpendicular-secondary-pipe",
        "one-to-two-parallel-secondary-pipe",
        "one-to-two-L-FL-pipe",
        "one-to-two-L-FR-pipe",
        "one-to-two-L-RL-pipe",
        "one-to-two-L-RR-pipe",
        "one-to-three-forward-pipe",
        "one-to-three-left-pipe",
        "one-to-three-reverse-pipe",
        "one-to-three-right-pipe",
        "one-to-four-pipe",
        "underground-i-pipe",
        "underground-L-pipe",
        "underground-t-pipe",
        "underground-cross-pipe"
    }

    local t2_underground_pipes = {
        "one-to-one-forward-t2-pipe",
        "one-to-one-left-t2-pipe",
        "one-to-one-reverse-t2-pipe",
        "one-to-one-right-t2-pipe",
        "one-to-two-perpendicular-t2-pipe",
        "one-to-two-parallel-t2-pipe",
        "one-to-two-perpendicular-secondary-t2-pipe",
        "one-to-two-parallel-secondary-t2-pipe",
        "one-to-two-L-FL-t2-pipe",
        "one-to-two-L-FR-t2-pipe",
        "one-to-two-L-RL-t2-pipe",
        "one-to-two-L-RR-t2-pipe",
        "one-to-three-forward-t2-pipe",
        "one-to-three-left-t2-pipe",
        "one-to-three-reverse-t2-pipe",
        "one-to-three-right-t2-pipe",
        "one-to-four-t2-pipe",
        "underground-i-t2-pipe",
        "underground-L-t2-pipe",
        "underground-t-t2-pipe",
        "underground-cross-t2-pipe"
    }

    local t3_underground_pipes = {
        "one-to-one-forward-t3-pipe",
        "one-to-one-left-t3-pipe",
        "one-to-one-reverse-t3-pipe",
        "one-to-one-right-t3-pipe",
        "one-to-two-perpendicular-t3-pipe",
        "one-to-two-parallel-t3-pipe",
        "one-to-two-perpendicular-secondary-t3-pipe",
        "one-to-two-parallel-secondary-t3-pipe",
        "one-to-two-L-FL-t3-pipe",
        "one-to-two-L-FR-t3-pipe",
        "one-to-two-L-RL-t3-pipe",
        "one-to-two-L-RR-t3-pipe",
        "one-to-three-forward-t3-pipe",
        "one-to-three-left-t3-pipe",
        "one-to-three-reverse-t3-pipe",
        "one-to-three-right-t3-pipe",
        "one-to-four-t3-pipe",
        "underground-i-t3-pipe",
        "underground-L-t3-pipe",
        "underground-t-t3-pipe",
        "underground-cross-t3-pipe"
    }

    local t1_distance = data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
    local t2_distance = data.raw["pipe-to-ground"]["niobium-pipe-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
    local t3_distance = data.raw["pipe-to-ground"]["ht-pipes-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
    if settings.startup["afhfp-longer-undergrounds"].value then
        t1_distance = t1_distance + 1
        t2_distance = t2_distance + 1
        t3_distance = t3_distance + 1
    end

    local t1_extent   = data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.max_pipeline_extent
    local t2_extent   = data.raw["pipe-to-ground"]["niobium-pipe-to-ground"].fluid_box.max_pipeline_extent
    local t3_extent   = data.raw["pipe-to-ground"]["ht-pipes-to-ground"].fluid_box.max_pipeline_extent

    for _, name in pairs(t1_underground_pipes) do
        data.raw["pipe-to-ground"][name].fluid_box.max_pipeline_extent = t1_extent
        for k, v in pairs(data.raw["pipe-to-ground"][name].fluid_box.pipe_connections) do
            if v.connection_type == "underground" then
                v.max_underground_distance = t1_distance
            end
        end
    end

    for _, name in pairs(t2_underground_pipes) do
        name = data.raw["pipe-to-ground"][name].fluid_box
        name.max_pipeline_extent = t2_extent
        name.pipe_connections[1] = util.table.deepcopy(name.pipe_connections[1])
        for k, v in pairs(name.pipe_connections) do
            if v.connection_type == "underground" then
                v.max_underground_distance = t2_distance
            end
            if braided then
                v.connection_category = "niobium-pipe"
            end
        end
    end

    for _, name in pairs(t3_underground_pipes) do
        name = data.raw["pipe-to-ground"][name].fluid_box
        name.max_pipeline_extent = t3_extent
        name.pipe_connections[1] = util.table.deepcopy(name.pipe_connections[1])
        for k, v in pairs(name.pipe_connections) do
            if v.connection_type == "underground" then
                v.max_underground_distance = t3_distance
            end
            if braided then
                v.connection_category = "ht-pipes"
            end
        end
    end

--  Adjust underground pumps
    local defspeed = data.raw["pump"]["pump"].pumping_speed
    local defenerg = data.raw["pump"]["pump"].energy_usage
    for k, v in pairs(data.raw["pump"]) do
        if v.name == 'underground-mini-pump' then
            for _, conn in pairs(v.fluid_box.pipe_connections) do
                conn.max_underground_distance = t1_distance
            end
            v.pumping_speed = defspeed
            v.energy_usage = defenerg
            v.icons = { {icon = v.icon, icon_size = v.icon_size, tint = {r=255,g=191,b=0} } }
            for _, animlayers in pairs(v.animations) do
                for _, layer in pairs(animlayers.layers) do
                    if string.find(layer.filename, 'hr-ug-arrow', 1, true) ~= nil then
                        layer.tint = {r=255,g=191,b=0,a=0.5}
                    end
                end
            end
        elseif v.name == 'underground-mini-pump-t2' then
            for _, conn in pairs(v.fluid_box.pipe_connections) do
                conn.max_underground_distance = t2_distance
                if braided then
                    conn.connection_category = "niobium-pipe"
                end
            end
            v.pumping_speed = defspeed
            v.energy_usage = defenerg
            v.icons = { {icon = v.icon, icon_size = v.icon_size, tint = {r=227,g=38,b=45} } }
            for _, animlayers in pairs(v.animations) do
                for _, layer in pairs(animlayers.layers) do
                    if string.find(layer.filename, 'hr-ug-arrow', 1, true) ~= nil then
                        layer.tint = {r=227,g=38,b=45,a=0.5}
                    end
                end
            end
        elseif v.name == 'underground-mini-pump-t3' then
            for _, conn in pairs(v.fluid_box.pipe_connections) do
                conn.max_underground_distance = t3_distance
                if braided then
                    conn.connection_category = "ht-pipes"
                end
            end
            v.pumping_speed = defspeed
            v.energy_usage = defenerg
            v.icons = { {icon = v.icon, icon_size = v.icon_size, tint = {r=38,g=173,b=227} } }
        end
    end

--  Adjust item recipes
    data.raw.recipe["underground-mini-pump"].ingredients = {
        {name = "iron-plate", amount = 4, type = "item"},
        {name = "pump", amount = 1, type = "item"},
        {name = "small-pipe-coupler", amount = 2, type = "item"},
        {name = "underground-pipe-segment-t1", amount = 10, type = "item"}
    }

    data.raw.recipe["underground-mini-pump-t2"].ingredients = {
        {name = "niobium-plate", amount = 4, type = "item"},
        {name = "pump", amount = 1, type = "item"},
        {name = "medium-pipe-coupler", amount = 2, type = "item"},
        {name = "underground-pipe-segment-t2", amount = 10, type = "item"}
    }

    data.raw.recipe["underground-mini-pump-t3"].ingredients = {
        {name = "niobium-plate", amount = 2, type = "item"},
        {name = "titanium-plate", amount = 2, type = "item"},
        {name = "rubber", amount = 4, type = "item"},
        {name = "pump", amount = 1, type = "item"},
        {name = "large-pipe-coupler", amount = 2, type = "item"},
        {name = "underground-pipe-segment-t3", amount = 10, type = "item"}
    }

    data.raw.recipe["medium-pipe-coupler"].ingredients = {
        {name = "small-pipe-coupler", amount = 1, type = "item"},
        {name = "niobium-plate", amount = 1, type = "item"},
    }

    data.raw.recipe["large-pipe-coupler"].ingredients = {
        {name = "medium-pipe-coupler", amount = 1, type = "item"},
        {name = "rubber", amount = 1, type = "item"},
        {name = "plastic-bar", amount = 1, type = "item"},
    }

    data.raw.recipe["underground-pipe-segment-t2"].ingredients = {
        {name = "underground-pipe-segment-t1", amount = 1, type = "item"},
        {name = "niobium-plate", amount = 1, type = "item"}
    }

    data.raw.recipe["underground-pipe-segment-t3"].ingredients = {
        {name = "underground-pipe-segment-t2", amount = 1, type = "item"},
        {name = "rubber", amount = 1, type = "item"},
        {name = "plastic-bar", amount = 1, type = "item"},
    }

--  Adjust technology requirements
    data.raw.technology["advanced-underground-piping-t2"].prerequisites = {
        "advanced-underground-piping",
        "niobium"
    }

    data.raw.technology["advanced-underground-piping-t3"].prerequisites = {
        "advanced-underground-piping-t2",
        "coal-processing-3"
    }

-- Adjust valves' flow rates
    for k, v in pairs(data.raw["valve"]) do
        v.flow_rate = v.flow_rate * 2
    end

-- Apply the Pyanodon-flavored names (Iron / Niobium / Multipurpose).
-- Done via localised_name/description so it only applies under Py and does not
-- change the stock AFH locale for regular installs.
    local function relocalise(category, names)
        for _, n in pairs(names) do
            local proto = data.raw[category][n]
            if proto then
                proto.localised_name = {"py-afh-entity-name." .. n}
                proto.localised_description = {"py-afh-entity-description." .. n}
            end
        end
    end

    relocalise("pipe-to-ground", t1_underground_pipes)
    relocalise("pipe-to-ground", t2_underground_pipes)
    relocalise("pipe-to-ground", t3_underground_pipes)
    relocalise("pump", {"underground-mini-pump", "underground-mini-pump-t2", "underground-mini-pump-t3"})

    local py_item_names = {
        "swivel-joint",
        "small-pipe-coupler",
        "medium-pipe-coupler",
        "large-pipe-coupler",
        "underground-pipe-segment-t1",
        "underground-pipe-segment-t2",
        "underground-pipe-segment-t3",
    }
    for _, n in pairs(py_item_names) do
        local item = data.raw.item[n]
        if item then
            item.localised_name = {"py-afh-item-name." .. n}
            item.localised_description = {"py-afh-item-description." .. n}
        end
    end

    local py_techs = {
        "advanced-underground-piping",
        "advanced-underground-piping-t2",
        "advanced-underground-piping-t3",
    }
    for _, n in pairs(py_techs) do
        local tech = data.raw.technology[n]
        if tech then
            tech.localised_name = {"py-afh-technology-name." .. n}
            tech.localised_description = {"py-afh-technology-description." .. n}
        end
    end

    local group = data.raw["item-group"]["advanced-underground-piping"]
    if group then
        group.localised_name = {"py-afh-item-group-name.advanced-underground-piping"}
    end
end
