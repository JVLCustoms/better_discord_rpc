# Better Discord RPC

A feature-rich Discord Rich Presence script for FiveM servers with advanced customization options.

## Features

- Dynamic Rich Presence based on player activity
- Vehicle-aware status display (cars, motorcycles, boats, planes, etc.)
- Location-based status (city, Sandy Shores, Paleto Bay, ocean)
- Customizable button support (up to 2 buttons)
- ESX integration
- Placeholder support for server name, player count, max players, etc.
- Performance optimized with separate update threads

## Installation

1. Download the latest release
2. Extract the `better_discord_rpc` folder to your FiveM server's `resources` directory
3. Add `ensure better_discord_rpc` to your server.cfg
4. Configure the script in `config.lua`

## Configuration

Edit the `config.lua` file to customize your Discord Rich Presence:

```lua
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
    
    -- And more options...
}
```

## Creating Discord Application

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application" and give it a name
3. Go to the "Rich Presence" tab
4. Upload your images with descriptive names (these are used in the config)
5. Copy your Application ID and set it in the `config.lua` file

## Placeholders

You can use the following placeholders in your status and details text:

- `{servername}` - Server name from server.cfg
- `{maxplayers}` - Maximum player count
- `{playercount}` - Current player count
- `{playername}` - Current player's name

## Buttons

You can configure up to 2 buttons:

```lua
Buttons = {
    {
        Text = "Join Server", 
        Url = "fivem://connect/yourserver.com:30120"
    },
    {
        Text = "Discord",
        Url = "https://discord.gg/yourinvite"
    }
}
```

The first button must use either `fivem://` or `https://` protocol, while the second button must use `https://`.

## Requirements

- FiveM server
- Discord client
- ESX framework

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Developed by JVL Customs