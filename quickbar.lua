-- Carl Frank Otto III
-- carlotto81@gmail.com
-- GitHub: https://github.com/M45-Science/SoftMod
-- License: MPL 2.0

function ExportQuickbar(player, limit)
    if not player or not player.valid then
        return
    end

    local outbuf = ""
    local maxExport = 100
    if limit then
        maxExport = 20
    end

    for i = 1, maxExport do
        local slot = player.get_quick_bar_slot(i)
        if slot ~= nil then
            local quality = slot.quality or "normal"
            outbuf = outbuf .. slot.name .. ":" .. quality
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
                item = parts[1] or ""
                quality = parts[2] or "normal"
            end

            local valid_item = prototypes.item and prototypes.item[item]
            local valid_quality = prototypes.quality and prototypes.quality[quality]

            if valid_item and valid_quality then
                if version == "M45-QB2" and quality ~= "normal" then
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
