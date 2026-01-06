-- Carl Frank Otto III
-- carlotto81@gmail.com
-- GitHub: https://github.com/M45-Science/SoftMod
-- License: MPL 2.0

local FORCEDEL_BUTTON_NAME = "m45_force_delete_toggle"
local FORCEDEL_SPRITE = "file/img/buttons/force-delete-64.png"

local function is_armed(player)
    return storage and storage.PData and storage.PData[player.index] and storage.PData[player.index].force_delete_armed
end

local function set_armed(player, armed)
    if not (player and player.valid) then
        return
    end
    STORAGE_EnsureGlobal()
    STORAGE_MakePlayerStorage(player)

    storage.PData[player.index].force_delete_armed = armed and true or false
end

local function draw_button(player)
    if not (player and player.valid and player.gui and player.gui.top) then
        return
    end

    if not player.admin then
        if player.gui.top[FORCEDEL_BUTTON_NAME] then
            player.gui.top[FORCEDEL_BUTTON_NAME].destroy()
        end
        return
    end

    local button = player.gui.top[FORCEDEL_BUTTON_NAME]
    if not button then
        button = player.gui.top.add {
            type = "sprite-button",
            name = FORCEDEL_BUTTON_NAME,
            sprite = FORCEDEL_SPRITE,
            tooltip = "Force delete (admin): enable, then click an entity"
        }
        button.style.size = { 64, 64 }
    end

    -- Use toggled state for the orange highlight (matches other top-bar tool buttons).
    button.toggled = is_armed(player) and true or false
end

function FORCEDEL_MakeButton(player)
    draw_button(player)
end

function FORCEDEL_Clicks(event)
    if not (event and event.element and event.element.valid and event.player_index) then
        return
    end
    if event.element.name ~= FORCEDEL_BUTTON_NAME then
        return
    end

    local player = game.players[event.player_index]
    if not (player and player.valid and player.admin) then
        return
    end

    local armed = is_armed(player)
    set_armed(player, not armed)
    draw_button(player)
end

local function force_delete_entity(player, entity)
    if not (player and player.valid and entity and entity.valid) then
        return
    end

    local gps = UTIL_GPSObj(entity)
    local name = entity.name

    set_armed(player, false)
    draw_button(player)

    entity.destroy { raise_destroy = true }
    UTIL_SmartPrint(player, "[FORCE-DELETE] " .. name .. " " .. gps)
end

function FORCEDEL_OnGuiOpened(event)
    if not (event and event.player_index) then
        return
    end

    local player = game.players[event.player_index]
    if not (player and player.valid and player.admin) then
        return
    end

    if not is_armed(player) then
        return
    end

    if event.gui_type ~= defines.gui_type.entity then
        return
    end

    local entity = event.entity
    if entity and entity.valid then
        if player.opened == entity then
            player.opened = nil
        end
        force_delete_entity(player, entity)
    end
end
