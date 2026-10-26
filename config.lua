--[[
    Better Discord RPC | Configuration
    Shows your server in the player's Discord profile: images, up to 2 buttons and a text line that
    rotates between what the player is doing, their character and the player count.

    Setup: https://discord.com/developers/applications -> your app -> copy the Application ID, then
    upload your images in Rich Presence > Art Assets and use their names below.
    On Qbox turn off the built-in one: qbx_core/config/client.lua -> discord.enabled = false

    No tables, no convars, no items. Works on Qbox, QBCore, ESX and standalone (auto-detected).
]]

Config = {}

Config.AppId = 'YOUR_APP_ID_HERE'       -- REQUIRED. Not set = the script does nothing (prints a warning in F8)
Config.Locale = 'auto'                  -- 'auto' (player's GTA language) | 'es' | 'en'
Config.UpdateInterval = 15000           -- ms between updates (Discord throttles anything faster than ~15 s)

Config.LargeImage = { name = 'YOUR_LARGE_IMAGE_NAME', text = 'YOUR SERVER NAME' }
Config.SmallImage = { name = '', text = '' } -- name = '' -> no small image

-- Up to 2 buttons. Links must start with https:// or fivem://
Config.Buttons = {
    { text = 'Join server', url = 'https://cfx.re/join/YOUR_SERVER_CODE' },
    { text = 'Discord', url = 'https://discord.gg/YOUR_INVITE_HERE' },
}

-- Lines shown one after another on every update.
-- Placeholders: {activity} {charName} {playerName} {id} {players} {maxPlayers} {playersWord} {zone} {street}
Config.Lines = {
    '{activity}',
    '{charName} · ID {id}',
    '{players}/{maxPlayers} {playersWord}',
}

--- True when the local player is dead / downed. CHANGE TO YOUR AMBULANCE SYSTEM if needed.
---@return boolean
function Config.IsPlayerDead()
    if GetResourceState('wasabi_ambulance') == 'started' then return exports.wasabi_ambulance:isPlayerDead() and true or false end
    if GetResourceState('qbx_medical') == 'started' then
        return exports.qbx_medical:IsDead() or exports.qbx_medical:IsLaststand()
    end
    -- if GetResourceState('ars_ambulancejob') == 'started' then return LocalPlayer.state.dead end
    return IsEntityDead(PlayerPedId()) or LocalPlayer.state.isDead == true
end
