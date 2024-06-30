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