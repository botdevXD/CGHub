repeat
    task.wait()
until game:IsLoaded()

if shared.CG_CURRENT_WINDOW then
    pcall(function()
        shared.CG_CURRENT_WINDOW:Unload()
        shared.CG_CURRENT_WINDOW = nil

        for _, Object in ipairs(game:GetService("CoreGui"):GetDescendants()) do
            if Object:IsA("ScreenGui") and Object.Name == "Drawing" then
                for _, Object2 in ipairs(Object:GetDescendants()) do
                    Object2:Destroy()
                end
            end
        end
    end)
end

local ClonedPlaceId = game.PlaceId
local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/NOTI_LIB.lua", true))()

NotiLib.new("info", "Bloxfruits", "join The discord server (copied to clipboard), https://discord.gg/DAssqn8XET")
NotiLib.new("info", "Bloxfruits", "Bloxfruits Script Loading")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/Roblox-UI-Libs/main/xsx%20Lib/xsx%20Lib%20Source.lua", true))()

local Services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local Vars = {
    Player = Services.Players.LocalPlayer,
    RemotesFolder = Services.ReplicatedStorage:WaitForChild("Remotes", 5),
    CommunicationRemotesFolder = Services.ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5)
}

local Remotes = {
    RigControllerEvent = Services.ReplicatedStorage:WaitForChild("RigControllerEvent", 5),
    NPCFunction = Vars.CommunicationRemotesFolder:WaitForChild("CommF_", 5)
}

local window = Library:New({
    Name = "CG's Bloxfruits Script",
    Theme = "Dark",
    Accent = Color3.fromRGB(50, 100, 255),
    Bind = Enum.KeyCode.V
})

shared.CG_CURRENT_WINDOW = window

--[[

local args = {
    [1] = "weaponChange",
    [2] = "Combat"
}

local args = {
    [1] = "unequipWeapon",
    [2] = "Combat"
} -- RigControllerEvent

local args = {
    [1] = "StartQuest",
    [2] = "BanditQuest1",
    [3] = 1
} -- CommF_

]]