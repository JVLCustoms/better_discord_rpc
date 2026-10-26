--[[
    Discord Rich Presence: images, buttons and a rotating text line
    (activity, character, players) in the player's own language.
]]

if not tonumber(Config.AppId) then
    return print('^3[better_discord_rpc] Config.AppId is not set, rich presence disabled.^7')
end

-- ---------------------------------------------------------------------
-- Framework (only for the character name and the loaded flag)
-- ---------------------------------------------------------------------

local function iniciado(recurso) return GetResourceState(recurso) == 'started' end

local function datosJugador()
    if iniciado('qbx_core') then return exports.qbx_core:GetPlayerData() end
    if iniciado('qb-core') then return exports['qb-core']:GetCoreObject().Functions.GetPlayerData() end
    if iniciado('es_extended') then return exports.es_extended:getSharedObject().GetPlayerData() end
end

local function cargado()
    if iniciado('qbx_core') or iniciado('qb-core') then return LocalPlayer.state.isLoggedIn == true end
    if iniciado('es_extended') then return exports.es_extended:getSharedObject().IsPlayerLoaded() end
    return true
end

local function nombrePersonaje()
    local datos = datosJugador()
    if not datos then return end
    if datos.firstName and datos.lastName then return ('%s %s'):format(datos.firstName, datos.lastName) end -- ESX
    local info = datos.charinfo
    return info and info.firstname and ('%s %s'):format(info.firstname, info.lastname or '') or datos.name
end

-- ---------------------------------------------------------------------
-- Language (GTA V language of the player when Locale = 'auto')
-- ---------------------------------------------------------------------

local idiomasJuego = { [0] = 'en', 'fr', 'de', 'it', 'es', 'pt', 'pl', 'ru', 'ko', 'zh', 'ja', 'es', 'zh' }
local idioma = Config.Locale
if idioma == 'auto' then idioma = idiomasJuego[GetCurrentLanguage()] or 'en' end
if not Locales[idioma] then idioma = 'en' end

local function T(clave, ...)
    local texto = Locales[idioma][clave] or Locales.en[clave] or clave
    if select('#', ...) > 0 then return texto:format(...) end
    return texto
end

-- ---------------------------------------------------------------------
-- What the player is doing
-- ---------------------------------------------------------------------

local clasesVehiculo = { [8] = 'motorcycle', [13] = 'bicycle', [14] = 'boat', [15] = 'helicopter', [16] = 'plane', [21] = 'train' }

local function lugar(ped)
    local c = GetEntityCoords(ped)
    local zona = GetLabelText(GetNameOfZone(c.x, c.y, c.z))
    local calle = GetStreetNameFromHashKey(GetStreetNameAtCoord(c.x, c.y, c.z))
    return zona ~= 'NULL' and zona or '', calle or ''
end

local function actividad(ped, zona, calle)
    if not cargado() then return T('loading') end
    if Config.IsPlayerDead() then return T('dead') end
    local donde = calle ~= '' and zona ~= '' and ('%s, %s'):format(calle, zona) or (zona ~= '' and zona or calle)

    local vehiculo = GetVehiclePedIsIn(ped, false)
    if vehiculo ~= 0 then
        local clave = clasesVehiculo[GetVehicleClass(vehiculo)]
        -- Planes, helicopters, boats and trains read better with the zone only
        if clave and clave ~= 'motorcycle' and clave ~= 'bicycle' then return T(clave, zona) end
        if GetPedInVehicleSeat(vehiculo, -1) ~= ped then return T('passenger', donde) end
        return T(clave or 'car', donde)
    end
    if IsPedSwimming(ped) then return T('swimming', zona) end
    return T('walking', donde)
end

local function render(plantilla)
    local ped, jugador = PlayerPedId(), PlayerId()
    local zona, calle = lugar(ped)
    local valores = {
        activity = actividad(ped, zona, calle),
        charName = nombrePersonaje() or GetPlayerName(jugador),
        playerName = GetPlayerName(jugador),
        id = tostring(GetPlayerServerId(jugador)),
        players = tostring(GlobalState.rpcPlayers or #GetActivePlayers()),
        maxPlayers = tostring(GlobalState.rpcMaxPlayers or '?'),
        playersWord = T('players'),
        zone = zona,
        street = calle,
    }
    return (plantilla:gsub('{(%w+)}', function(clave) return valores[clave] or '' end))
end

-- ---------------------------------------------------------------------
-- Presence
-- ---------------------------------------------------------------------

local function configurar()
    SetDiscordAppId(Config.AppId)
    if Config.LargeImage and Config.LargeImage.name ~= '' then
        SetDiscordRichPresenceAsset(Config.LargeImage.name)
        SetDiscordRichPresenceAssetText(Config.LargeImage.text or '')
    end
    if Config.SmallImage and Config.SmallImage.name ~= '' then
        SetDiscordRichPresenceAssetSmall(Config.SmallImage.name)
        SetDiscordRichPresenceAssetSmallText(Config.SmallImage.text or '')
    end
    for i, boton in ipairs(Config.Buttons or {}) do
        if i > 2 then break end
        if boton.url:find('^https://') or boton.url:find('^fivem://') then
            SetDiscordRichPresenceAction(i - 1, boton.text, boton.url)
        else
            print(('^3[better_discord_rpc] button %s ignored, the link must start with https:// or fivem://^7'):format(i))
        end
    end
end

CreateThread(function()
    configurar()
    local lineas = #(Config.Lines or {}) > 0 and Config.Lines or { '{activity}' }
    local indice, ultimo = 0, nil
    while true do
        indice = indice % #lineas + 1
        local texto = render(lineas[indice])
        if texto ~= ultimo then
            SetRichPresence(texto)
            ultimo = texto
        end
        Wait(math.max(Config.UpdateInterval or 15000, 5000))
    end
end)
