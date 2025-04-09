

-- Config section (add this at the top of your script)    
Config = {
    -- Discord App Information
    AppId = "YOUR BOT ID HERE", -- Replace with your Discord Application ID
    UseNewer = true, -- Use newer version of Rich Presence for better compatibility
    UpdateInterval = 60000, -- Update interval in ms (1 minute)
    
    -- Images
    LargeImage = "img name", -- Name of your large image in Discord Developer Portal
    LargeText = "Server Name", -- Text that appears when hovering over the large image
    SmallImage = "img name", -- Name of your small image as is in Discord Developer Portal
    SmallText = "Description", -- Text that appears when hovering over the small image
    
    -- Display Settings
    ShowVehicle = true,    -- Show vehicle status
    LocationStatus = true, -- Show location status
    
    -- Format Strings
    StatusFormat = "Playing on {servername}",
    DetailsFormat = "{playercount}/{maxplayers} players",
    
    -- Vehicle Status Texts
    VehicleTexts = {
        ["Car"] = "Driving a car",
        ["Motorcycle"] = "Riding a motorcycle",
        ["Bicycle"] = "Riding a bicycle",
        ["Boat"] = "Sailing a boat",
        ["Helicopter"] = "Flying a helicopter",
        ["Plane"] = "Flying a plane",
        ["default"] = "In a vehicle"
    },
    
    -- Location Status Texts
    LocationTexts = {
        ["City"] = "In Los Santos",
        ["Sandy Shores"] = "In Sandy Shores",
        ["Paleto Bay"] = "In Paleto Bay",
        ["Ocean"] = "Swimming in the ocean",
        ["default"] = "Exploring San Andreas"
    },
    
    -- Discord Buttons (up to 2)
    Buttons = {
        {
            Text = "Join Server",
            Url = "fivem://connect/localhost:000000" -- Replace with your server address
        },
        {
            Text = "Discord",
            Url = "https://discord.gg/youinvite" -- Replace with your Discord invite
        }
    },
    
    -- Debug mode
    Debug = false -- Set to true for debugging information in console
}