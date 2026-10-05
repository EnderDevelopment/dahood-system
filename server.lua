local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('dahood:getSettings', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM dahood_settings WHERE player_id = @player_id', {
        ['@player_id'] = playerId
    }, function(result)
        if result[1] then
            cb(result[1])
        else
            MySQL.Async.execute('INSERT INTO dahood_settings (player_id) VALUES (@player_id)', {
                ['@player_id'] = playerId
            }, function()
                cb({
                    silent_aim = true,
                    esp = true,
                    fog_changer = true,
                    head_invisibility = true,
                    radius = 50.0,
                    hitbox_expander = true,
                    visibility = 1.0
                })
            end)
        end
    end)
end)

RegisterNetEvent('dahood:updateSettings')
AddEventHandler('dahood:updateSettings', function(setting, value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.execute('UPDATE dahood_settings SET ' .. setting .. ' = @value WHERE player_id = @player_id', {
        ['@value'] = value,
        ['@player_id'] = playerId
    }, function(rowsChanged)
        if rowsChanged == 0 then
            MySQL.Async.execute('INSERT INTO dahood_settings (player_id, ' .. setting .. ') VALUES (@player_id, @value)', {
                ['@player_id'] = playerId,
                ['@value'] = value
            })
        end
    end)
end)