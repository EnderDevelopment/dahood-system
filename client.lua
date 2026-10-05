local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- GUI and Visual Effects
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 288) then -- F1 key
            OpenDahoodMenu()
        end
    end
end)

function OpenDahoodMenu()
    local elements = {
        {label = 'Silent Aim', value = 'silent_aim', type = 'checkbox', checked = Config.Dahood.SilentAim},
        {label = 'ESP', value = 'esp', type = 'checkbox', checked = Config.Dahood.ESP},
        {label = 'Fog Changer', value = 'fog_changer', type = 'checkbox', checked = Config.Dahood.FogChanger},
        {label = 'Head Invisibility', value = 'head_invisibility', type = 'checkbox', checked = Config.Dahood.HeadInvisibility},
        {label = 'Radius', value = 'radius', type = 'slider', min = 10.0, max = 100.0, step = 1.0, default = Config.Dahood.Radius},
        {label = 'Hitbox Expander', value = 'hitbox_expander', type = 'checkbox', checked = Config.Dahood.HitboxExpander},
        {label = 'Visibility', value = 'visibility', type = 'slider', min = 0.1, max = 1.0, step = 0.1, default = Config.Dahood.Visibility}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dahood_menu', {
        title = 'Dahood System',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'silent_aim' then
            Config.Dahood.SilentAim = data.current.checked
            TriggerServerEvent('dahood:updateSettings', 'silent_aim', data.current.checked)
        elseif data.current.value == 'esp' then
            Config.Dahood.ESP = data.current.checked
            TriggerServerEvent('dahood:updateSettings', 'esp', data.current.checked)
        elseif data.current.value == 'fog_changer' then
            Config.Dahood.FogChanger = data.current.checked
            TriggerServerEvent('dahood:updateSettings', 'fog_changer', data.current.checked)
        elseif data.current.value == 'head_invisibility' then
            Config.Dahood.HeadInvisibility = data.current.checked
            TriggerServerEvent('dahood:updateSettings', 'head_invisibility', data.current.checked)
        elseif data.current.value == 'radius' then
            Config.Dahood.Radius = data.current.default
            TriggerServerEvent('dahood:updateSettings', 'radius', data.current.default)
        elseif data.current.value == 'hitbox_expander' then
            Config.Dahood.HitboxExpander = data.current.checked
            TriggerServerEvent('dahood:updateSettings', 'hitbox_expander', data.current.checked)
        elseif data.current.value == 'visibility' then
            Config.Dahood.Visibility = data.current.default
            TriggerServerEvent('dahood:updateSettings', 'visibility', data.current.default)
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Silent Aim
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.SilentAim then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            if closestPlayer ~= -1 and closestDistance <= Config.Dahood.Radius then
                local targetPed = GetPlayerPed(closestPlayer)
                local targetCoords = GetEntityCoords(targetPed)

                if IsPlayerFreeAiming(PlayerId()) then
                    SetPedShootsAtCoord(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, true)
                end
            end
        end
    end
end)

-- ESP
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.ESP then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if targetPed ~= playerPed then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)

                    if distance <= Config.Dahood.Radius then
                        DrawMarker(1, targetCoords.x, targetCoords.y, targetCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                    end
                end
            end
        end
    end
end)

-- Fog Changer
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.FogChanger then
            SetArtificialFog(true, 1.0, 1.0, 1.0, 1.0, 1.0)
        else
            SetArtificialFog(false, 1.0, 1.0, 1.0, 1.0, 1.0)
        end
    end
end)

-- Head Invisibility
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.HeadInvisibility then
            local playerPed = PlayerPedId()
            SetEntityVisible(playerPed, false, false)
        else
            local playerPed = PlayerPedId()
            SetEntityVisible(playerPed, true, false)
        end
    end
end)

-- Hitbox Expander
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.HitboxExpander then
            local playerPed = PlayerPedId()
            SetPedConfigFlag(playerPed, 223, true)
        else
            local playerPed = PlayerPedId()
            SetPedConfigFlag(playerPed, 223, false)
        end
    end
end)

-- Visibility
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Dahood.Visibility < 1.0 then
            local playerPed = PlayerPedId()
            SetEntityAlpha(playerPed, math.floor(Config.Dahood.Visibility * 255), false)
        else
            local playerPed = PlayerPedId()
            SetEntityAlpha(playerPed, 255, false)
        end
    end
end)