local AimPredictionAmount = 0.15
local AimPrediction = true
local AimPart = "Head"
local PlayerPing = 100

local Camera = game:GetService("Workspace").CurrentCamera

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ClosestDistance = math.huge
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
                local Distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Character[AimPart].Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestPlayer = v
                    ClosestDistance = Distance
                end
            end
        end
    end
    return ClosestPlayer
end

local function PredictAim(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild(AimPart) then
        local Distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Player.Character[AimPart].Position).Magnitude
        local Time = Distance / PlayerPing
        local Velocity = Player.Character.HumanoidRootPart.Velocity
        local PredictedPosition = Player.Character[AimPart].Position + Velocity * Time * AimPredictionAmount
        return PredictedPosition
    end
end

local function aimAt(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild(AimPart) then
        local PredictedPosition = PredictAim(Player)
        if PredictedPosition then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, PredictedPosition)
        end
    end
end

local Players = game.Players
local Player = Players.LocalPlayer

local Character = Player.Character

shared.antiLock = not shared.antiLock

local function calculateHipHeight(character)
    local joints = {
        {
            PartName = "HumanoidRootPart",
            From	 = nil,
            To		 = "RootRigAttachment"
        },
        {
            PartName = "LowerTorso",
            From	 = "RootRigAttachment",
            To		 = "RightHipRigAttachment"
        },
        {
            PartName = "RightUpperLeg",
            From	 = "RightHipRigAttachment",
            To		 = "RightKneeRigAttachment"
        },
        {
            PartName = "RightLowerLeg",
            From	 = "RightKneeRigAttachment",
            To		 = "RightAnkleRigAttachment"
        },
        {
            PartName = "RightFoot",
            From	 = "RightAnkleRigAttachment",
            To		 = nil
        }	
    }

    local hipHeight = 0
    
    pcall(function()
        for _, entry in pairs(joints) do
            pcall(function()
                local fromPos = entry.From and character[entry.PartName][entry.From].Position or Vector3.new(0, 0, 0)
                local toPos	  = entry.To and character[entry.PartName][entry.To].Position or -character[entry.PartName].Size / 2  	
    
                hipHeight = hipHeight + fromPos.Y - toPos.Y
            end)
        end

        hipHeight = hipHeight - character.PrimaryPart.Size.Y / 2
    end)

    return hipHeight	
end

while shared.antiLock do
    local oldvelocity = Character.PrimaryPart.AssemblyLinearVelocity
    Character.Humanoid.HipHeight = 270
    Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(oldvelocity.X, -5000, oldvelocity.Z)
    Character.PrimaryPart.AssemblyLinearVelocity = oldvelocity
    Character.Humanoid.HipHeight = 270
    Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(oldvelocity.X, -5000, oldvelocity.Z)
    Character.Humanoid.HipHeight = 270

    task.wait()
end

Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
Character.Humanoid.HipHeight = calculateHipHeight(Character)