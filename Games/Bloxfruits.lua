repeat
    task.wait()
until game:IsLoaded()

local ClonedPlaceId = game.PlaceId
local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/NOTI_LIB.lua", true))()

NotiLib.new("info", "CG Da Hood", "join The discord server (copied to clipboard), https://discord.gg/DAssqn8XET")
NotiLib.new("info", "CG Da Hood", "CG's Da Hood Script Loading")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/Roblox-UI-Libs/main/xsx%20Lib/xsx%20Lib%20Source.lua", true))()

local Services = {
    Players = game:GetService("Players")
}
local Vars = {
    Player = Services.Players.LocalPlayer
}