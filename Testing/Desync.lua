-- Desync anti aim lock (fake lagginess)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DesyncEnabled = false

local function SetDesyncEnabled(Enabled)
    DesyncEnabled = Enabled
end

local function GetDesyncEnabled()
    return DesyncEnabled
end

local function SetNetworkSettings()
    if DesyncEnabled then
        settings().Network.IncomingReplicationLag = 1
    else
        settings().Network.IncomingReplicationLag = 0
    end
end

SetNetworkSettings()