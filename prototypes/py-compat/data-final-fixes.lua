-- Pyanodon compatibility - data-final-fixes stage.
-- Reskins the added pipe-to-grounds so they visually match Py's pipes, overlaying
-- directional arrows tinted per tier. Ported from the standalone
-- "Advanced Fluid Handling For PyMods" addon (Dremon, created by Sopel).
-- Only required when pyindustry + pyhightech are present.
do
    if settings.startup["afhfp-reskin-pipe-to-grounds"].value then
        local variants = {
            ["one-to-one-forward"] = {
                north = "S",
                south = "N",
                west = "E",
                east = "W"
            },
            ["one-to-one-right"] = {
                north = "W",
                south = "E",
                west = "S",
                east = "N"
            },
            ["one-to-one-reverse"] = {
                north = "N",
                south = "S",
                west = "W",
                east = "E"
            },
            ["one-to-one-left"] = {
                north = "E",
                south = "W",
                west = "N",
                east = "S"
            },
            ["one-to-two-parallel"] = {
                north = "NS",
                south = "NS",
                west = "EW",
                east = "EW"
            },
            ["one-to-two-L-FR"] = {
                north = "SW",
                south = "NE",
                west = "ES",
                east = "NW"
            },
            ["one-to-two-perpendicular"] = {
                north = "EW",
                south = "EW",
                west = "NS",
                east = "NS"
            },
            ["one-to-two-L-RR"] = {
                north = "NW",
                south = "ES",
                west = "SW",
                east = "NE"
            },
            ["one-to-two-parallel-secondary"] = {
                north = "NS",
                south = "NS",
                west = "EW",
                east = "EW"
            },
            ["one-to-two-L-RL"] = {
                north = "NE",
                south = "SW",
                west = "NW",
                east = "ES"
            },
            ["one-to-two-perpendicular-secondary"] = {
                north = "EW",
                south = "EW",
                west = "NS",
                east = "NS"
            },
            ["one-to-two-L-FL"] = {
                north = "ES",
                south = "NW",
                west = "NE",
                east = "SW"
            },
            ["one-to-three-forward"] = {
                north = "ESW",
                south = "NEW",
                west = "NES",
                east = "NSW"
            },
            ["one-to-three-right"] = {
                north = "NSW",
                south = "NES",
                west = "ESW",
                east = "NEW"
            },
            ["one-to-three-reverse"] = {
                north = "NEW",
                south = "ESW",
                west = "NSW",
                east = "NES"
            },
            ["one-to-three-left"] = {
                north = "NES",
                south = "NSW",
                west = "NEW",
                east = "ESW"
            },
            ["one-to-four"] = {
                north = "NESW",
                south = "NESW",
                west = "NESW",
                east = "NESW"
            },
        }

        local tiers = {
            [1] = {
                base_pipe = "pipe-to-ground",
                name = "",
                color = {r=255,g=191,b=0,a=0.5},
                shifts = {
                    up = {0, 0},
                    down = {0, 0},
                    left = {0, 0},
                    right = {0, 0}
                },
                distance = data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
            },
            [2] = {
                base_pipe = "niobium-pipe-to-ground",
                name = "-t2",
                color = {r=227,g=38,b=45,a=0.5},
                shifts = {
                    up = {0, 0},
                    down = {0, 0},
                    left = {0, 0},
                    right = {0, 0}
                },
                distance = data.raw["pipe-to-ground"]["niobium-pipe-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
            },
            [3] = {
                base_pipe = "ht-pipes-to-ground",
                name = "-t3",
                color = {r=38,g=173,b=227,a=0.5},
                shifts = {
                    up = {0, -0.25},
                    down = {0, -0.28},
                    left = {0, -0.25},
                    right = {0, -0.25}
                },
                distance = data.raw["pipe-to-ground"]["ht-pipes-to-ground"].fluid_box.pipe_connections[2].max_underground_distance
            }
        }

        for name, dirmap in pairs(variants) do
            for tier, tier_traits in pairs(tiers) do
                local color = tier_traits.color
                local fullname = name .. tier_traits.name .. "-pipe"
                local p = data.raw["pipe-to-ground"][fullname]
                local base = data.raw["pipe-to-ground"][tier_traits.base_pipe]
                for dir, pic in pairs(p.pictures) do
                    local curpic = util.table.deepcopy(base.pictures[dir])
                    local arrows = "__advanced-fluid-handling-forked__/graphics/entity/arrows/hr-ug-arrow-" .. dirmap[dir] .. ".png"
                    p.pictures[dir] = {
                        layers = {
                            curpic,
                            {
                                filename = arrows,
                                priority = "extra-high",
                                width = 96,
                                height = 96,
                                shift = tier_traits.shifts[dir],
                                scale = 0.5,
                                apply_runtime_tint = true,
                                tint = color,
                            }
                        }
                    }

                    p.fluid_box.pipe_covers = util.table.deepcopy(base.fluid_box.pipe_covers)
                end
            end
        end
    end
end
