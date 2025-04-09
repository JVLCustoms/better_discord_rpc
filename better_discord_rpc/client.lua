ESX = exports["es_extended"]:getSharedObject()

-- Variables locales
local playerCount = 0
local playerZone = "default"
local currentVehicle = "none"

-- Mapa simplificado de zonas
local zoneList = {
    ["CITY"] = "City",
    ["SANDY"] = "Sandy Shores",
    ["PALETO"] = "Paleto Bay",
    ["OCEANA"] = "Ocean",
    ["OCEANN"] = "Ocean",
    ["OCEANP"] = "Ocean"
}

-- Mapa simplificado de vehículos
local vehicleTypes = {
    [0] = "Car", -- Compacts
    [1] = "Car", -- Sedans
    [2] = "Car", -- SUVs
    [3] = "Car", -- Coupes
    [4] = "Car", -- Muscle
    [8] = "Motorcycle", -- Motorcycles
    [13] = "Bicycle", -- Cycles
    [14] = "Boat", -- Boats
    [15] = "Helicopter", -- Helicopters
    [16] = "Plane", -- Planes
    ["default"] = "Car"
}

-- Función para obtener número de jugadores
function GetPlayerCount()
    local count = 0
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end
    return count
end

-- Función simplificada para obtener la zona actual
function GetCurrentZone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Verificar si está en agua
    if IsEntityInWater(ped) then
        return "Ocean"
    end
    
    -- Verificar coordenadas (simplificado)
    if coords.y > 4000 then
        return "Paleto Bay"
    elseif coords.y > 2500 then
        return "Sandy Shores"
    else
        return "City"
    end
end

-- Función para obtener tipo de vehículo
function GetVehicleType()
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleClass = GetVehicleClass(vehicle)
        
        return vehicleTypes[vehicleClass] or vehicleTypes["default"]
    else
        return "none"
    end
end

-- Función para reemplazar placeholders en texto
function ReplacePlaceholders(text)
    local result = text
    
    -- Obtener información del servidor
    local serverName = GetConvar("sv_hostname", "Servidor FiveM")
    local maxPlayers = GetConvarInt("sv_maxclients", 32)
    
    -- Reemplazar placeholders básicos
    result = result:gsub("{servername}", serverName)
    result = result:gsub("{maxplayers}", tostring(maxPlayers))
    result = result:gsub("{playercount}", tostring(playerCount))
    result = result:gsub("{playername}", GetPlayerName(PlayerId()))
    
    return result
end

-- Función principal para actualizar Discord Rich Presence
function UpdateRichPresence()
    -- Actualizar información
    playerCount = GetPlayerCount()
    playerZone = GetCurrentZone()
    currentVehicle = GetVehicleType()
    
    -- Configurar status según vehículo o ubicación
    local status = ReplacePlaceholders(Config.StatusFormat)
    local details = ReplacePlaceholders(Config.DetailsFormat)
    
    -- Si está en un vehículo y la opción está activada
    if Config.ShowVehicle and currentVehicle ~= "none" then
        status = Config.VehicleTexts[currentVehicle] or Config.VehicleTexts["default"]
    -- Si no, mostrar ubicación si está activada
    elseif Config.LocationStatus then
        status = Config.LocationTexts[playerZone] or Config.LocationTexts["default"]
    end
    
    -- Debug
    if Config.Debug then
        print("Status: " .. status)
        print("Details: " .. details)
        print("Zone: " .. playerZone)
        print("Vehicle: " .. currentVehicle)
    end
    
    -- Configurar Discord Rich Presence
    SetDiscordAppId(Config.AppId)
    
    -- Limpiar Rich Presence antes de actualizarlo (intentar evitar problemas de caché)
    SetRichPresence("")
    
    -- Imágenes
    SetDiscordRichPresenceAsset(Config.LargeImage)
    SetDiscordRichPresenceAssetText(Config.LargeText)
    
    if Config.SmallImage and Config.SmallImage ~= "" then
        SetDiscordRichPresenceAssetSmall(Config.SmallImage)
        SetDiscordRichPresenceAssetSmallText(Config.SmallText)
    end
    
    -- Forzar actualización con retardo
    Citizen.Wait(500)
    
    -- Establecer detalles y estado
    SetRichPresence(status .. " | " .. details)
    
    -- También establecer los campos de forma individual para mayor compatibilidad
    SetDiscordRichPresenceAssetText(status)
    SetDiscordRichPresenceAssetSmallText(details)
    
    -- Botones (Asegurar que siempre se configuren)
    -- El primer botón debe ser de tipo fivem:// o https://
    if Config.Buttons and #Config.Buttons > 0 then
        if Config.Buttons[1] then
            -- Verifica que el URL comience con fivem:// o https://
            local url = Config.Buttons[1].Url
            if not (url:sub(1, 8) == "fivem://" or url:sub(1, 8) == "https://") then
                url = "fivem://" .. url
            end
            SetDiscordRichPresenceAction(0, Config.Buttons[1].Text, url)
            
            if Config.Debug then
                print("Botón 1 configurado: " .. Config.Buttons[1].Text .. " - " .. url)
            end
        end
        
        if Config.Buttons[2] then
            -- Verifica que el URL comience con fivem:// o https://
            local url = Config.Buttons[2].Url
            if not (url:sub(1, 8) == "fivem://" or url:sub(1, 8) == "https://") then
                url = "https://" .. url
            end
            SetDiscordRichPresenceAction(1, Config.Buttons[2].Text, url)
            
            if Config.Debug then
                print("Botón 2 configurado: " .. Config.Buttons[2].Text .. " - " .. url)
            end
        end
    else
        -- Botones por defecto si no hay configuración
        SetDiscordRichPresenceAction(0, "Unirse al servidor", "fivem://connect/localhost:30120")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/yourserver")
        
        if Config.Debug then
            print("Usando botones por defecto")
        end
    end
end

-- Bucle principal
Citizen.CreateThread(function()
    -- Dar tiempo para que todo se inicialice correctamente
    Citizen.Wait(10000)
    
    -- Log inicial
    print("Iniciando Better Discord RPC...")
    print("ID de Aplicación: " .. Config.AppId)
    
    -- Forzar primera actualización
    SetDiscordAppId(Config.AppId)
    SetRichPresence("Iniciando...")
    
    -- Una pequeña pausa para asegurar que se inicialice
    Citizen.Wait(2000)
    
    -- Bucle principal
    while true do
        UpdateRichPresence()
        Citizen.Wait(Config.UpdateInterval)
    end
end)

-- Bucle para actualizar información más frecuentemente
Citizen.CreateThread(function()
    while true do
        playerCount = GetPlayerCount()
        playerZone = GetCurrentZone()
        currentVehicle = GetVehicleType()
        Citizen.Wait(5000) -- Cada 5 segundos
    end
end)