-- made by CG

local aimviewModule = {}

shared.CG_AIM_VIEWER_ENABLED = false

function aimviewModule.EnableAndDisableAimView()
    shared.CG_AIM_VIEWER_ENABLED = not shared.CG_AIM_VIEWER_ENABLED
end

local runService = game:GetService("RunService")
local Players = game:GetService("Players")
local MyPlayer = Players.LocalPlayer

shared.CG_AIM_VIEWER_CONNECTIONS = shared.CG_AIM_VIEWER_CONNECTIONS or {}
shared.CG_AIM_VIEWER_CachedParts = shared.CG_AIM_VIEWER_CachedParts or {}

for _, Connection in ipairs(shared.CG_AIM_VIEWER_CONNECTIONS) do
    pcall(Connection.Disconnect, Connection)
end

for _, Part in pairs(shared.CG_AIM_VIEWER_CachedParts) do
    pcall(Part.Destroy, Part)
end

table.clear(shared.CG_AIM_VIEWER_CONNECTIONS)
table.clear(shared.CG_AIM_VIEWER_CachedParts)

local function makeSignal(event, func)
    shared.CG_AIM_VIEWER_CONNECTIONS[#shared.CG_AIM_VIEWER_CONNECTIONS + 1] = event:Connect(func)
end

makeSignal(runService.RenderStepped, function()
    for _, Player in ipairs(Players:GetChildren()) do
        if Player ~= MyPlayer then
            local Character = Player.Character
            local currentTool = Character and Character:FindFirstChildWhichIsA("Tool")
            local currentToolHandle = currentTool and currentTool:FindFirstChild("Handle")
            local hasAmmo = (currentTool and currentTool:FindFirstChild("Ammo")) or (currentTool and currentTool:GetAttribute("Ammo") ~= nil)
            local playerMousePos = Character and Character:FindFirstChild("MousePos", true)

            if not shared.CG_AIM_VIEWER_ENABLED then
                if shared.CG_AIM_VIEWER_CachedParts[Player] then
                    shared.CG_AIM_VIEWER_CachedParts[Player]:Destroy()
                    shared.CG_AIM_VIEWER_CachedParts[Player] = nil
                end
                continue
            end

            if hasAmmo and playerMousePos and playerMousePos:IsA("Vector3Value") and currentToolHandle and currentToolHandle:IsA("BasePart") then
                local mousePos = playerMousePos.Value
                
                local distance = (currentToolHandle.Position - mousePos).Magnitude
                local cylinder = shared.CG_AIM_VIEWER_CachedParts[Player] or Instance.new("Part")
                cylinder.Anchored = true
                cylinder.CanCollide = false
                cylinder.CastShadow = false
                cylinder.Size = Vector3.new(0.1, 0.1, distance)
                cylinder.CFrame = CFrame.new(currentToolHandle.Position, mousePos) * CFrame.new(0, 0, -distance / 2)
                cylinder.Parent = workspace.CurrentCamera
                cylinder.Transparency = 0
                cylinder.Color = Color3.fromRGB(255, 0, 0)
                cylinder.Material = Enum.Material.SmoothPlastic

                shared.CG_AIM_VIEWER_CachedParts[Player] = cylinder
            else
                if shared.CG_AIM_VIEWER_CachedParts[Player] then
                    shared.CG_AIM_VIEWER_CachedParts[Player]:Destroy()
                    shared.CG_AIM_VIEWER_CachedParts[Player] = nil
                end
            end
        end
    end
end)

makeSignal(Players.PlayerRemoving, function(Player)
    if shared.CG_AIM_VIEWER_CachedParts[Player] then
        shared.CG_AIM_VIEWER_CachedParts[Player]:Destroy()
        shared.CG_AIM_VIEWER_CachedParts[Player] = nil
    end
end)

return aimviewModule