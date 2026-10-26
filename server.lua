--[[
    Player count and slots for the clients (GlobalState), same on every framework.
]]

local function actualizar()
    GlobalState.rpcPlayers = #GetPlayers()
end

GlobalState.rpcMaxPlayers = GetConvarInt('sv_maxclients', 48)
actualizar()

AddEventHandler('playerJoining', actualizar)
AddEventHandler('playerDropped', function()
    SetTimeout(500, actualizar) -- the dropped player is still listed during the event
end)
