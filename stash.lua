-- Helper: Check if player is valid and controlling a character
function is_player_valid(player)
    return player
       and player.valid
       and player.connected
       and player.character
       and player.character.valid
       and player.controller_type == defines.controllers.character
end

-- Helper: Check if inventory is empty using get_item_count()
function is_inventory_empty(inventory)
    if not inventory then return true end
    return inventory.get_item_count() == 0
end

local function quality_id_from_stack(stack)
    if not stack then
        return nil
    end
    local quality = stack.quality
    if quality == nil then
        return nil
    end
    if type(quality) == "string" then
        return quality
    end
    if quality.name then
        return quality.name
    end
    return nil
end

local function stack_definition_from_stack(stack)
    local def = { name = stack.name, count = stack.count }
    local quality = quality_id_from_stack(stack)
    if quality ~= nil then
        def.quality = quality
    end
    return def
end

-- Ensure a particular stash is empty or create it fresh
function ensure_empty_stash(player_index, stash_name, size)
    if storage.PData[player_index][stash_name] then
        local stash = storage.PData[player_index][stash_name]
        if not stash.is_empty() then
            return false -- It's not empty
        else
            return true
        end
    else
        storage.PData[player_index][stash_name] = game.create_inventory(size)
        return true
    end
end

-- Stash items from a source inventory into a target stash inventory, using can_insert()
function stash_inventory(source_inv, stash_inv)
    if not source_inv or not stash_inv then return false, false end
    local stashed_anything = false
    local stash_full = false

    for i = 1, #source_inv do
        local stack = source_inv[i]
        if stack.valid_for_read then
            local stack_to_insert = stack_definition_from_stack(stack)
            if stash_inv.can_insert(stack_to_insert) then
                local inserted_count = stash_inv.insert(stack_to_insert)
                if inserted_count > 0 then
                    if inserted_count < stack.count then
                        stack.count = stack.count - inserted_count
                        stash_full = true
                    else
                        stack.clear()
                    end
                    stashed_anything = true
                else
                    stash_full = true
                end
            else
                stash_full = true
            end
        end
    end
    return stashed_anything, stash_full
end

-- Unstash items from a stash inventory into a target player inventory, using can_insert()
function unstash_inventory(stash_inv, target_inv)
    if not stash_inv or not target_inv then return false, false end
    local unstashed_anything = false
    local player_inventory_full = false

    for i = 1, #stash_inv do
        local stack = stash_inv[i]
        if stack.valid_for_read then
            local stack_to_insert = stack_definition_from_stack(stack)
            if target_inv.can_insert(stack_to_insert) then
                local inserted_count = target_inv.insert(stack_to_insert)
                if inserted_count > 0 then
                    if inserted_count < stack.count then
                        stack.count = stack.count - inserted_count
                        player_inventory_full = true
                    else
                        stack.clear()
                    end
                    unstashed_anything = true
                else
                    player_inventory_full = true
                end
            else
                player_inventory_full = true
            end
        end
    end
    return unstashed_anything, player_inventory_full
end

-- Stash armor and its equipment, using can_insert
function stash_armor(player)
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or armor_inventory.is_empty() then
        return false, false
    end

    local stashed_anything = false
    local stash_full = false

    for i = 1, #armor_inventory do
        local stack = armor_inventory[i]
        if stack.valid_for_read then
            -- If it's armor with equipment, store equipment data
            if stack.grid and stack.grid.valid then
                local equipment_data = {}
                for _, eq in pairs(stack.grid.equipment) do
                    equipment_data[#equipment_data + 1] = {
                        name = eq.name,
                        position = eq.position,
                        energy = eq.energy
                    }
                end
                table.sort(equipment_data, function(a, b)
                    if a.position.y ~= b.position.y then
                        return a.position.y < b.position.y
                    end
                    if a.position.x ~= b.position.x then
                        return a.position.x < b.position.x
                    end
                    return a.name < b.name
                end)
                storage.PData[player.index].armor_equipment_data = equipment_data
            else
                storage.PData[player.index].armor_equipment_data = nil
            end

            local armor_stash = storage.PData[player.index].armor_stash
            local stack_to_insert = stack_definition_from_stack(stack)
            if armor_stash.can_insert(stack_to_insert) then
                local inserted_count = armor_stash.insert(stack_to_insert)
                if inserted_count > 0 then
                    if inserted_count < stack.count then
                        stack.count = stack.count - inserted_count
                        stash_full = true
                    else
                        stack.clear()
                    end
                    stashed_anything = true
                else
                    stash_full = true
                end
            else
                stash_full = true
            end
        end
    end

    return stashed_anything, stash_full
end

-- Unstash armor and restore equipment, using can_insert
function unstash_armor(player)
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    local armor_stash = storage.PData[player.index].armor_stash
    if not armor_stash then return false, false end

    local unstashed_anything = false
    local player_inventory_full = false

    for i = 1, #armor_stash do
        local stack = armor_stash[i]
        if stack.valid_for_read then
            local stack_to_insert = stack_definition_from_stack(stack)
            if armor_inventory.can_insert(stack_to_insert) then
                local inserted_count = armor_inventory.insert(stack_to_insert)
                if inserted_count > 0 then
                    if inserted_count < stack.count then
                        stack.count = stack.count - inserted_count
                        player_inventory_full = true
                    else
                        stack.clear()
                    end
                    unstashed_anything = true

                    -- Restore equipment if we have any saved
                    if storage.PData[player.index].armor_equipment_data then
                        local new_armor_stack = armor_inventory[1] -- The inserted armor should be here
                        if new_armor_stack and new_armor_stack.valid_for_read and new_armor_stack.grid then
                            for _, eq_data in ipairs(storage.PData[player.index].armor_equipment_data) do
                                local eq = new_armor_stack.grid.put({ name = eq_data.name, position = eq_data.position })
                                if eq then
                                    eq.energy = eq_data.energy
                                end
                            end
                        end
                        storage.PData[player.index].armor_equipment_data = nil
                    end
                else
                    player_inventory_full = true
                end
            else
                player_inventory_full = true
            end
        end
    end

    return unstashed_anything, player_inventory_full
end

-- Helper: Move items from one inventory to another if possible, otherwise leave them
function move_items_to_inventory_or_leave(source_inv, target_inv)
    if not source_inv or not target_inv then return end
    for i = 1, #source_inv do
        local stack = source_inv[i]
        if stack.valid_for_read then
            local stack_to_transfer = stack_definition_from_stack(stack)
            -- Check if we can fully insert into target_inv
            if target_inv.can_insert(stack_to_transfer) then
                local inserted = target_inv.insert(stack_to_transfer)
                if inserted > 0 then
                    stack.clear()
                end
                -- If somehow inserted < stack.count even though can_insert was true, 
                -- that would be odd, but in theory can_insert should ensure full insertion.
            else
                -- Cannot insert this stack fully, leave it as is.
            end
        end
    end
end

-- Command registration moved to commands_stash.lua
function STASH_AddStashCommands()
    -- see commands_stash.lua
end
