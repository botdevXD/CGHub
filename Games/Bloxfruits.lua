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

shared.CG_BLOXFRUITS_CONNECTIONS = shared.CG_BLOXFRUITS_CONNECTIONS or {}

for _, Connection in pairs(shared.CG_BLOXFRUITS_CONNECTIONS) do
    pcall(Connection.Disconnect, Connection)
end

table.clear(shared.CG_BLOXFRUITS_CONNECTIONS)

local function makeConnection(event, callback)
    local connection = event:Connect(callback)

    table.insert(shared.CG_BLOXFRUITS_CONNECTIONS, connection)

    return connection
end

local ClonedPlaceId = game.PlaceId
local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/NOTI_LIB.lua", true))()

NotiLib.new("info", "Bloxfruits", "join The discord server (copied to clipboard), https://discord.gg/DAssqn8XET")
NotiLib.new("info", "Bloxfruits", "Bloxfruits Script Loading")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/Roblox-UI-Libs/main/xsx%20Lib/xsx%20Lib%20Source.lua", true))()

local CG_ESP_LIB = shared.CG_HUB_DEPENDENCIES.CG_ESP_LIB

local Services = {
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local Vars = {
    Player = Services.Players.LocalPlayer,
    RemotesFolder = Services.ReplicatedStorage:WaitForChild("Remotes", 5),
    CommunicationRemotesFolder = Services.ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5),
    EnemiesFolder = workspace:WaitForChild("Enemies", 5),
    NPCsFolder = workspace:WaitForChild("NPCs", 5),
    BoatsFolder = workspace:WaitForChild("Boats", 5)
}

Vars.Character = Vars.Player.Character or Vars.Player.CharacterAdded:Wait()

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

local PlayerTab = window:Page({Name = "Player"})
local VisualsTab = window:Page({Name = "Visuals"})
local MiscTab = window:Page({Name = "Misc"})

local MiscSectionLeft = MiscTab:Section({Name = "Main", Side = "Left"})
local PlayerSectionLeft = PlayerTab:Section({Name = "Main", Side = "Left"})
local VisualsSectionLeft = VisualsTab:Section({Name = "Main", Side = "Left"})

local combatToolNames = {
    "Dark Blade",
    "Combat",
    "Black Leg",
    "SharkSaw",
    "Trident",
    "TripleKatana",
    "WardenSword"
}

makeConnection(Vars.Player.CharacterAdded, function(newCharacter)
    Vars.Character = newCharacter
end)

local function getNearByEnemies()
    local enemies = {}

    for _, Enemy in ipairs(Vars.EnemiesFolder:GetChildren()) do
        local Humanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then continue end

        table.insert(enemies, Enemy)
    end

    return enemies
end

local function findCombatTool()
    if not Vars.Character then return end

    local backPack = Vars.Player:FindFirstChildWhichIsA("Backpack")
    if not backPack then return end

    for _, combatToolName in ipairs(combatToolNames) do
        local backpackTool = backPack:FindFirstChild(combatToolName)
        local characterTool = Vars.Character:FindFirstChild(combatToolName)
        
        if backpackTool or characterTool then
            return backpackTool or characterTool
        end
    end
end

VisualsSectionLeft:Toggle({
    Name = "Box",
    Default = false,
    flag = "espBoxes",
    Callback = function(toggleBool)
        CG_ESP_LIB.EnableAndDisableBoxes()
    end,
})

VisualsSectionLeft:Toggle({
    Name = "Nametag",
    Default = false,
    flag = "espNameTags",
    Callback = function(toggleBool)
        CG_ESP_LIB.EnableAndDisableNametags()
    end,
})

VisualsSectionLeft:Toggle({
    Name = "Tracers",
    Default = false,
    flag = "espTracers",
    Callback = function(toggleBool)
        CG_ESP_LIB.EnableAndDisableTracers()
    end,
})

VisualsSectionLeft:Toggle({
    Name = "Health Bar",
    Default = false,
    flag = "espHealthBar",
    Callback = function(toggleBool)
        CG_ESP_LIB.EnableAndDisableHealthBar()
    end,
})

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

makeConnection(Services.RunService.Heartbeat, function()
    
end)