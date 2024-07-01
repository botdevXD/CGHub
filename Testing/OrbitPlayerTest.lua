local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local currentTeleportBodyPosition = nil

local function teleport_func_test(teleportPos)
	if not Player.Character then return end
	if typeof(teleportPos) ~= "Vector3" then return end

	if not currentTeleportBodyPosition or not currentTeleportBodyPosition:IsDescendantOf(workspace) then
		currentTeleportBodyPosition = nil
	end

	local bodyPosition = currentTeleportBodyPosition or Instance.new("BodyPosition")
	bodyPosition.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyPosition.D = 300
	bodyPosition.Position = teleportPos
	bodyPosition.Parent = Player.Character.PrimaryPart

	currentTeleportBodyPosition = bodyPosition
end

local function clearTeleportBodyPos()
	if currentTeleportBodyPosition then
		pcall(currentTeleportBodyPosition.Destroy, currentTeleportBodyPosition)
	end
end

local function orbitPlayer(targetPlayer, distance, speed)
    local offset = Vector3.new(0, distance, 0)
    local character = Player.Character
    
    while targetPlayer:IsDescendantOf(Players) and character:IsDescendantOf(workspace) do
        local Humanoid = character:WaitForChild("Humanoid")
        if not Humanoid then task.wait(); continue end

        local rootPart = character:WaitForChild("HumanoidRootPart")
        if not rootPart then task.wait(); continue end
    
        local targetCharacter = targetPlayer.Character
        if not targetCharacter then task.wait(); continue end

        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")
        if not targetRootPart then task.wait(); continue end

        local position = targetRootPart.Position + offset
        local x = position.X + math.sin(tick() * speed) * distance
        local z = position.Z + math.cos(tick() * speed) * distance

        teleport_func_test(Vector3.new(x, (position.Y - targetRootPart.Size.Y) - (rootPart.Size.Y * 3.85) , z))

        RunService.RenderStepped:Wait()
    end

    clearTeleportBodyPos()
end

orbitPlayer(Players["DatBig0ilf"], 10, 5)