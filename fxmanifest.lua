fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'better_discord_rpc'
author 'JVL Customs'
description 'Better Discord RPC - Discord Rich Presence with live activity, character name and player count (Qbox, QBCore, ESX, standalone)'
version '2.0.0'

-- No dependencies. The framework (if any) is detected at runtime.
shared_scripts {
    'locales/*.lua',
    'config.lua',
}

client_script 'client.lua'
server_script 'server.lua'
