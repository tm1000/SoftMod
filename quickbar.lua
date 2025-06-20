-- Carl Frank Otto III
-- carlotto81@gmail.com
-- GitHub: https://github.com/M45-Science/SoftMod
-- License: MPL 2.0

local QUALITY_ALIAS = {
    uncommon = "u",
    rare = "r",
    epic = "e",
    legendary = "l",
}

local QUALITY_FROM_ALIAS = {}
for k, v in pairs(QUALITY_ALIAS) do
    QUALITY_FROM_ALIAS[v] = k
end

local ITEM_ALIAS = {}
local ITEM_FROM_ALIAS = {}

local ITEM_LIST = {
    "accumulator",
    "active-provider-chest",
    "advanced-circuit",
    "agricultural-science-pack",
    "agricultural-tower",
    "arithmetic-combinator",
    "artificial-jellynut-soil",
    "artificial-yumako-soil",
    "artillery-shell",
    "artillery-targeting-remote",
    "artillery-turret",
    "artillery-wagon",
    "artillery-wagon-cannon",
    "assembling-machine-1",
    "assembling-machine-2",
    "assembling-machine-3",
    "asteroid-collector",
    "atomic-bomb",
    "automation-science-pack",
    "barrel",
    "battery",
    "battery-equipment",
    "battery-mk2-equipment",
    "battery-mk3-equipment",
    "beacon",
    "belt-immunity-equipment",
    "big-electric-pole",
    "big-mining-drill",
    "biochamber",
    "bioflux",
    "biolab",
    "biter-egg",
    "blueprint",
    "blueprint-book",
    "boiler",
    "buffer-chest",
    "bulk-inserter",
    "burner-generator",
    "burner-inserter",
    "burner-mining-drill",
    "calcite",
    "cannon-shell",
    "captive-biter-spawner",
    "capture-robot-rocket",
    "car",
    "carbon",
    "carbon-fiber",
    "carbonic-asteroid-chunk",
    "cargo-bay",
    "cargo-landing-pad",
    "cargo-wagon",
    "centrifuge",
    "chemical-plant",
    "chemical-science-pack",
    "cliff-explosives",
    "cluster-grenade",
    "coal",
    "coin",
    "combat-shotgun",
    "concrete",
    "constant-combinator",
    "construction-robot",
    "copper-bacteria",
    "copper-cable",
    "copper-ore",
    "copper-plate",
    "copper-wire",
    "copy-paste-tool",
    "crude-oil-barrel",
    "crusher",
    "cryogenic-plant",
    "cryogenic-science-pack",
    "cut-paste-tool",
    "decider-combinator",
    "deconstruction-planner",
    "defender-capsule",
    "depleted-uranium-fuel-cell",
    "destroyer-capsule",
    "discharge-defense-equipment",
    "discharge-defense-remote",
    "display-panel",
    "distractor-capsule",
    "efficiency-module",
    "efficiency-module-2",
    "efficiency-module-3",
    "electric-energy-interface",
    "electric-engine-unit",
    "electric-furnace",
    "electric-mining-drill",
    "electromagnetic-plant",
    "electromagnetic-science-pack",
    "electronic-circuit",
    "empty-module-slot",
    "energy-shield-equipment",
    "energy-shield-mk2-equipment",
    "engine-unit",
    "exoskeleton-equipment",
    "explosive-cannon-shell",
    "explosive-rocket",
    "explosive-uranium-cannon-shell",
    "explosives",
    "express-loader",
    "express-splitter",
    "express-transport-belt",
    "express-underground-belt",
    "fast-inserter",
    "fast-loader",
    "fast-splitter",
    "fast-transport-belt",
    "fast-underground-belt",
    "firearm-magazine",
    "fission-reactor-equipment",
    "flamethrower",
    "flamethrower-ammo",
    "flamethrower-turret",
    "fluid-wagon",
    "fluoroketone-cold-barrel",
    "fluoroketone-hot-barrel",
    "flying-robot-frame",
    "foundation",
    "foundry",
    "fusion-generator",
    "fusion-power-cell",
    "fusion-reactor",
    "fusion-reactor-equipment",
    "gate",
    "green-wire",
    "grenade",
    "gun-turret",
    "hazard-concrete",
    "heat-exchanger",
    "heat-interface",
    "heat-pipe",
    "heating-tower",
    "heavy-armor",
    "heavy-oil-barrel",
    "holmium-ore",
    "holmium-plate",
    "ice",
    "ice-platform",
    "infinity-cargo-wagon",
    "infinity-chest",
    "infinity-pipe",
    "inserter",
    "iron-bacteria",
    "iron-chest",
    "iron-gear-wheel",
    "iron-ore",
    "iron-plate",
    "iron-stick",
    "item-unknown",
    "jelly",
    "jellynut",
    "jellynut-seed",
    "lab",
    "land-mine",
    "landfill",
    "lane-splitter",
    "laser-turret",
    "light-armor",
    "light-oil-barrel",
    "lightning-collector",
    "lightning-rod",
    "linked-belt",
    "linked-chest",
    "lithium",
    "lithium-plate",
    "loader",
    "locomotive",
    "logistic-robot",
    "logistic-science-pack",
    "long-handed-inserter",
    "low-density-structure",
    "lubricant-barrel",
    "mech-armor",
    "medium-electric-pole",
    "metallic-asteroid-chunk",
    "metallurgic-science-pack",
    "military-science-pack",
    "modular-armor",
    "night-vision-equipment",
    "nuclear-fuel",
    "nuclear-reactor",
    "nutrients",
    "offshore-pump",
    "oil-refinery",
    "one-way-valve",
    "overflow-valve",
    "overgrowth-jellynut-soil",
    "overgrowth-yumako-soil",
    "oxide-asteroid-chunk",
    "parameter-0",
    "parameter-1",
    "parameter-2",
    "parameter-3",
    "parameter-4",
    "parameter-5",
    "parameter-6",
    "parameter-7",
    "parameter-8",
    "parameter-9",
    "passive-provider-chest",
    "pentapod-egg",
    "personal-laser-defense-equipment",
    "personal-roboport-equipment",
    "personal-roboport-mk2-equipment",
    "petroleum-gas-barrel",
    "piercing-rounds-magazine",
    "piercing-shotgun-shell",
    "pipe",
    "pipe-to-ground",
    "pistol",
    "plastic-bar",
    "poison-capsule",
    "power-armor",
    "power-armor-mk2",
    "power-switch",
    "processing-unit",
    "production-science-pack",
    "productivity-module",
    "productivity-module-2",
    "productivity-module-3",
    "programmable-speaker",
    "promethium-asteroid-chunk",
    "promethium-science-pack",
    "proxy-container",
    "pump",
    "pumpjack",
    "quality-module",
    "quality-module-2",
    "quality-module-3",
    "quantum-processor",
    "radar",
    "rail",
    "rail-chain-signal",
    "rail-ramp",
    "rail-signal",
    "rail-support",
    "railgun",
    "railgun-ammo",
    "railgun-turret",
    "raw-fish",
    "recycler",
    "red-wire",
    "refined-concrete",
    "refined-hazard-concrete",
    "repair-pack",
    "requester-chest",
    "roboport",
    "rocket",
    "rocket-fuel",
    "rocket-launcher",
    "rocket-part",
    "rocket-silo",
    "rocket-turret",
    "science",
    "scrap",
    "selection-tool",
    "selector-combinator",
    "shotgun",
    "shotgun-shell",
    "simple-entity-with-force",
    "simple-entity-with-owner",
    "slowdown-capsule",
    "small-electric-pole",
    "small-lamp",
    "solar-panel",
    "solar-panel-equipment",
    "solid-fuel",
    "space-platform-foundation",
    "space-platform-hub",
    "space-platform-starter-pack",
    "space-science-pack",
    "speed-module",
    "speed-module-2",
    "speed-module-3",
    "spidertron",
    "spidertron-remote",
    "spidertron-rocket-launcher-1",
    "spidertron-rocket-launcher-2",
    "spidertron-rocket-launcher-3",
    "spidertron-rocket-launcher-4",
    "splitter",
    "spoilage",
    "stack-inserter",
    "steam-engine",
    "steam-turbine",
    "steel-chest",
    "steel-furnace",
    "steel-plate",
    "stone",
    "stone-brick",
    "stone-furnace",
    "stone-wall",
    "storage-chest",
    "storage-tank",
    "submachine-gun",
    "substation",
    "sulfur",
    "sulfuric-acid-barrel",
    "supercapacitor",
    "superconductor",
    "tank",
    "tank-cannon",
    "tank-flamethrower",
    "tank-machine-gun",
    "tesla-ammo",
    "tesla-turret",
    "teslagun",
    "thruster",
    "toolbelt-equipment",
    "top-up-valve",
    "train-stop",
    "transport-belt",
    "tree-seed",
    "tungsten-carbide",
    "tungsten-ore",
    "tungsten-plate",
    "turbo-loader",
    "turbo-splitter",
    "turbo-transport-belt",
    "turbo-underground-belt",
    "underground-belt",
    "upgrade-planner",
    "uranium-235",
    "uranium-238",
    "uranium-cannon-shell",
    "uranium-fuel-cell",
    "uranium-ore",
    "uranium-rounds-magazine",
    "utility-science-pack",
    "vehicle-machine-gun",
    "water-barrel",
    "wood",
    "wooden-chest",
    "yumako",
    "yumako-mash",
    "yumako-seed",
}

local function QUICKBAR_GenerateItemAliases()
    ITEM_ALIAS = {}
    ITEM_FROM_ALIAS = {}
    local function idx_to_alias(i)
        i = i - 1
        local a = math.floor(i / 26)
        local b = i % 26
        return string.char(65 + a) .. string.char(65 + b)
    end
    for i, name in ipairs(ITEM_LIST) do
        local alias = idx_to_alias(i)
        ITEM_ALIAS[name] = alias
        ITEM_FROM_ALIAS[alias] = name
    end
end

function ExportQuickbar(player, limit)
    if not player or not player.valid then
        return
    end

    local outbuf = ""
    local maxExport = 100
    if limit then
        maxExport = 20
    end

    if not next(ITEM_ALIAS) then
        QUICKBAR_GenerateItemAliases()
    end

    for i = 1, maxExport do
        local slot = player.get_quick_bar_slot(i)
        if slot ~= nil then
            local quality = slot.quality or "normal"
            local name = slot.name
            local ialias = ITEM_ALIAS[name]
            if ialias then
                outbuf = outbuf .. ialias
            else
                outbuf = outbuf .. name
            end
            if quality ~= "normal" then
                local alias = QUALITY_ALIAS[quality]
                if alias then
                    outbuf = outbuf .. ":" .. alias
                else
                    outbuf = outbuf .. ":" .. quality
                end
            end
        end
        outbuf = outbuf .. ","
    end

    UTIL_SmartPrint(player,"Quickbar Exported!")
    return helpers.encode_string("M45-QB2=" .. outbuf)
end


--Split with empty strings
function SplitStr(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function ImportQuickbar(player, data)
    if not player or not player.valid then
        return false
    end
    if data == nil or data == "" then
        return false
    end

    --Limit compressed size
    if string.len(data) > 10240 then
        UTIL_SmartPrint(player, "String too long.")
        return false
    end

    local decoded = helpers.decode_string(data)
    if decoded == nil or decoded == "" then
        UTIL_SmartPrint(player, "Could not decode that string.")
        return false
    end

    --Limit decompressed size
    if string.len(decoded) > 10240 then
        UTIL_SmartPrint(player, "String too long.")
        return false
    end

    local header = UTIL_SplitStr(decoded, "=")

    if not header or not header[1] then
        UTIL_SmartPrint(player, "That isn't a valid M45 quickbar exchange string! (No Header)")
        return false
    end

    local version = header[1]
    if version ~= "M45-QB1" and version ~= "M45-QB2" then
        UTIL_SmartPrint(player, "That isn't a valid M45 quickbar exchange string! (Invalid Header)")
        return false
    end

    --Clear all bars
    for i = 1, 100 do
        local slot = player.set_quick_bar_slot(i, nil)
    end

    --Restore from string
    local items = SplitStr(header[2], ",")

    local error_list = ""
    for i, entry in ipairs(items) do
        if i > 100 then
            return
        end

        if entry ~= "" then
            local item = entry
            local quality = "normal"

            if version == "M45-QB2" then
                local parts = UTIL_SplitStr(entry, ":")
                local ialias = parts[1] or ""
                item = ITEM_FROM_ALIAS[ialias] or ialias
                local qalias = parts[2]
                if qalias ~= nil then
                    quality = QUALITY_FROM_ALIAS[qalias] or qalias
                end
            else
                item = ITEM_FROM_ALIAS[item] or item
            end

            local valid_item = prototypes.item and prototypes.item[item]
            local valid_quality = prototypes.quality and prototypes.quality[quality]

            if valid_item and valid_quality then
                if quality ~= "normal" then
                    player.set_quick_bar_slot(i, { name = item, quality = quality })
                else
                    player.set_quick_bar_slot(i, item)
                end
            else
                if error_list ~= "" then
                    error_list = error_list .. ", "
                end
                if not valid_item then
                    error_list = error_list .. item
                else
                    error_list = error_list .. item .. ":" .. quality
                end
            end
        end
    end

    if error_list ~= "" then
        UTIL_SmartPrint(player, "Quickbar Import: Invalid items/qualities skipped: " .. error_list)
    else
        UTIL_SmartPrint(player, "Quickbar imported!")
    end

    return true
end

function QUICKBAR_MakeExchangeButton(player)
    QUICKBAR_ClearString(player)

    if player.gui.top.qb_exchange_button then
        player.gui.top.qb_exchange_button.destroy()
    end
    if not player.gui.top.qb_exchange_button then
        local ex_button = player.gui.top.add {
            type = "sprite-button",
            name = "qb_exchange_button",
            sprite = "file/img/buttons/exchange-64.png",
            tooltip = "Import or Export a M45 quickbar exchange string."
        }
        ex_button.style.size = { 64, 64 }
    end
end

function QUICKBAR_MakeExchangeWindow(player, exportMode)
    QUICKBAR_ClearString(player)

    if player.gui.screen.quickbar_exchange then
        player.gui.screen.quickbar_exchange.destroy()
    end
    local main_flow = player.gui.screen.add {
        type = "frame",
        name = "quickbar_exchange",
        direction = "vertical"
    }
    main_flow.style.horizontal_align = "center"
    main_flow.style.vertical_align = "center"
    main_flow.force_auto_center()

    -- Title Bar--
    local info_titlebar = main_flow.add {
        type = "flow",
        direction = "horizontal"
    }
    info_titlebar.drag_target = main_flow
    info_titlebar.style.horizontal_align = "center"
    info_titlebar.style.horizontally_stretchable = true

    info_titlebar.add {
        type = "label",
        name = "online_title",
        style = "frame_title",
        caption = "M45 Quickbar Exchange String"
    }
    local pusher = info_titlebar.add {
        type = "empty-widget",
        style = "draggable_space_header"
    }

    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = main_flow

    info_titlebar.add {
        type = "sprite-button",
        name = "qb_exchange_close",
        sprite = "utility/close",
        style = "frame_action_button",
        tooltip = "Close this window"
    }

    main_flow.style.padding = 4
    local mframe = main_flow.add {
        type = "flow",
        direction = "vertical"
    }
    mframe.style.minimal_height = 75
    mframe.style.horizontally_squashable = false

    local qbes = ""
    if exportMode then
        qbes = ExportQuickbar(player, false)
    end
    mframe.add {
        type = "text-box",
        name = "quickbar_string",
        text = qbes,
        tooltip = "COPY: Click text then Control-C\nPASTE: Click text then Control-V",
    }
    mframe.quickbar_string.style.minimal_width = 500
    mframe.quickbar_string.style.minimal_height = 50

    local bframe = mframe.add {
        type = "flow",
        direction = "horizontal"
    }
    bframe.add {
        type = "button",
        caption = "Import",
        style = "green_button",
        name = "import_qb",
        tooltip = "Import a new quickbar."
    }
    local pusher = bframe.add {
        type = "empty-widget",
    }
    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    bframe.add {
        type = "button",
        caption = "Export",
        style = "red_button",
        name = "export_qb",
        tooltip = "Export current quickbars."
    }
end

function QUICKBAR_Clicks(event)
    if event and event.element and event.element.valid and event.player_index then
        local player = game.players[event.player_index]

        if player and player.valid and event.element.name then
            if event.element.name == "quickbar_string" then
                event.element.select_all()
            end

            if event.element.name == "qb_exchange_close" and player.gui and player.gui.screen and
                player.gui.screen.quickbar_exchange then
                QUICKBAR_ClearString(player)
                player.gui.screen.quickbar_exchange.destroy()
            elseif event.element.name == "qb_exchange_button" and player.gui and player.gui.screen then
                if player.gui.screen.quickbar_exchange then
                    player.gui.screen.quickbar_exchange.destroy()
                    QUICKBAR_ClearString(player)
                else
                    QUICKBAR_MakeExchangeWindow(player, false)
                end
            elseif event.element.name == "export_qb" and player.gui and player.gui.screen then
                if player.gui.screen.quickbar_exchange then
                    QUICKBAR_ClearString(player)
                    player.gui.screen.quickbar_exchange.destroy()
                end
                QUICKBAR_MakeExchangeWindow(player, true)
            elseif event.element.name == "import_qb" and player.gui and player.gui.screen then
                if storage.PData and storage.PData[player.index] and
                    storage.PData[event.player_index].qb_import_string then
                    ImportQuickbar(player, storage.PData[event.player_index].qb_import_string)
                    QUICKBAR_ClearString(player)

                    if player.gui.screen.quickbar_exchange then
                        player.gui.screen.quickbar_exchange.destroy()
                    end
                end
            end
        end
    end
end

function QUICKBAR_ClearString(player)
    if not player or not player.valid then
        return
    end
    if storage.PData and storage.PData[player.index] and
        storage.PData[player.index].qb_import_string then
        storage.PData[player.index].qb_import_string = ""
    end
end

-- Grab text from text box
function QUICKBAR_TextChanged(event)
    if event and event.element and event.player_index and event.text and event.element.name then
        local player = game.players[event.player_index]

        if event.element.name == "quickbar_string" then
            if storage.PData and storage.PData[event.player_index] then
                --Limit import size
                if string.len(event.element.text) > 10240 then
                    event.element.text = "String too long."
                    return
                end
                storage.PData[event.player_index].qb_import_string = event.element.text
            end
        end
    end
end
