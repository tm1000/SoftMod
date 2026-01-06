-- Carl Frank Otto III
-- carlotto81@gmail.com
-- GitHub: https://github.com/M45-Science/SoftMod
-- License: MPL 2.0

local FORCEDEL_BUTTON_NAME = "m45_force_delete_toggle"

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

    storage.SM_Store.force_delete_armed_players = storage.SM_Store.force_delete_armed_players or {}
    if storage.PData[player.index].force_delete_armed then
        storage.SM_Store.force_delete_armed_players[player.index] = true
    else
        storage.SM_Store.force_delete_armed_players[player.index] = nil
    end
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
            type = "button",
            name = FORCEDEL_BUTTON_NAME,
            caption = "FD",
            tooltip = "Force delete (admin): enable, then try mining an unminable entity"
        }
        button.style = "mini_button"
    end

    if is_armed(player) then
        button.caption = "FD!"
        button.style = "mini_tool_button_red"
    else
        button.caption = "FD"
        button.style = "mini_button"
    end
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

function FORCEDEL_OnTick()
    if not (storage and storage.SM_Store and storage.SM_Store.force_delete_armed_players) then
        return
    end

    local armed_indices = {}
    for player_index, _ in pairs(storage.SM_Store.force_delete_armed_players) do
        armed_indices[#armed_indices + 1] = player_index
    end

    for i = 1, #armed_indices do
        local player_index = armed_indices[i]
        local player = game.players[player_index]
        if not (player and player.valid and player.connected and player.admin) then
            if player and player.valid then
                set_armed(player, false)
                draw_button(player)
            else
                storage.SM_Store.force_delete_armed_players[player_index] = nil
            end
        else
            local ms = player.mining_state
            local ent = ms and ms.mining and ms.entity
            if ent and ent.valid and (not ent.minable) then
                -- Debounce so one action only.
                STORAGE_MakePlayerStorage(player)
                local pdata = storage.PData[player.index]
                if pdata.force_delete_last_tick ~= game.tick then
                    pdata.force_delete_last_tick = game.tick
                    force_delete_entity(player, ent)
                end
            end
        end
    end
end
