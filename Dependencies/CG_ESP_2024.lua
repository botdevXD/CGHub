if shared.CG_ESP_FUNCTION_TABLE ~= nil then
	shared.CG_ESP_CONFIG = {
		BoxesEnabled = false,
		NametagsEnabled = false,
		TracersEnabled = false,
		HealthBarEnabled = false,
		ArmorBarEnabled = false,
		ESP_COLOR = Color3.fromRGB(255, 255, 255)
	}
	
	return shared.CG_ESP_FUNCTION_TABLE
end

local GUIService = game:GetService("GuiService")
local Players = game:GetService("Players")
local runService = game:GetService("RunService")

local DrawingNew = Drawing

local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

shared.CG_ESP_CONNECTIONS = shared.CG_ESP_CONNECTIONS or {}
shared.CG_ESP_cachedText = shared.CG_ESP_cachedText or {}
shared.CG_ESP_cachedBoxes = shared.CG_ESP_cachedBoxes or {}
shared.CG_ESP_cachedHealthBars = shared.CG_ESP_cachedHealthBars or {}
shared.CG_ESP_cachedArmorBars = shared.CG_ESP_cachedArmorBars or {}

for _, Connection in pairs(shared.CG_ESP_CONNECTIONS) do
	pcall(Connection.Disconnect, Connection)
end

table.clear(shared.CG_ESP_CONNECTIONS)

shared.CG_ESP_CONFIG = {
	BoxesEnabled = false,
	NametagsEnabled = false,
	TracersEnabled = false,
	HealthBarEnabled = false,
	ArmorBarEnabled = false,
	ESP_COLOR = Color3.fromRGB(255, 255, 255)
}

local esp_Module = {}

function esp_Module.EnableAndDisableBoxes(value)
	shared.CG_ESP_CONFIG.BoxesEnabled = value
end

function esp_Module.EnableAndDisableNametags(value)
	shared.CG_ESP_CONFIG.NametagsEnabled = value
end

function esp_Module.EnableAndDisableTracers(value)
	shared.CG_ESP_CONFIG.TracersEnabled = value
end

function esp_Module.EnableAndDisableHealthBar(value)
	shared.CG_ESP_CONFIG.HealthBarEnabled = value
end

function esp_Module.EnableAndDisableArmorBar(value)
	shared.CG_ESP_CONFIG.ArmorBarEnabled = value
end

shared.CG_ESP_FUNCTION_TABLE = esp_Module

local function unloadPlayerESP(foundClient)
	local leavingClientESPText = shared.CG_ESP_cachedText[foundClient]
	local leavingClientESPBox = shared.CG_ESP_cachedBoxes[foundClient]
	local leavingClientESPHealthBar = shared.CG_ESP_cachedHealthBars[foundClient]
	local leavingClientESPArmorBar = shared.CG_ESP_cachedArmorBars[foundClient]
	
	pcall(function()
		if leavingClientESPText ~= nil then
			leavingClientESPText:Destroy()
		end

		if leavingClientESPBox ~= nil then
			leavingClientESPBox:Destroy()
		end

		if leavingClientESPHealthBar ~= nil then
			leavingClientESPHealthBar:Destroy()
		end

		if leavingClientESPArmorBar ~= nil then
			leavingClientESPArmorBar:Destroy()
		end
	end)

	shared.CG_ESP_cachedText[foundClient] = nil
	shared.CG_ESP_cachedBoxes[foundClient] = nil
	shared.CG_ESP_cachedHealthBars[foundClient] = nil
	shared.CG_ESP_cachedArmorBars[foundClient] = nil
end

local function updatePlayerESP(espPlayer)
	local espCharacter = espPlayer.Character
	local box = shared.CG_ESP_cachedBoxes[espPlayer] or DrawingNew.new("Square")
	local HealthBar = shared.CG_ESP_cachedHealthBars[espPlayer] or DrawingNew.new("Square")
	local ArmorBar = shared.CG_ESP_cachedArmorBars[espPlayer] or DrawingNew.new("Square")
	local text = shared.CG_ESP_cachedText[espPlayer] or DrawingNew.new("Text")
	text.Size = 20
	text.Text = espPlayer.Name
	text.color = Color3.fromRGB(255, 255, 255)
	text.Outline = true

	shared.CG_ESP_cachedText[espPlayer] = shared.CG_ESP_cachedText[espPlayer] or text
	shared.CG_ESP_cachedBoxes[espPlayer] = shared.CG_ESP_cachedBoxes[espPlayer] or box
	shared.CG_ESP_cachedHealthBars[espPlayer] = shared.CG_ESP_cachedHealthBars[espPlayer] or HealthBar
	shared.CG_ESP_cachedArmorBars[espPlayer] = shared.CG_ESP_cachedArmorBars[espPlayer] or ArmorBar
	
	if not espCharacter then
		box.Visible = false
		HealthBar.Visible = false
		text.Visible = false
		return
	end

    local espHead = espCharacter:FindFirstChild("Head")
    local Humanoid = espCharacter:FindFirstChildWhichIsA("Humanoid")
    if not espHead or not Humanoid then
        box.Visible = false
		HealthBar.Visible = false
		text.Visible = false
        return
    end
	
	local PlayerCFrame = espCharacter:GetPivot()

	local rootPart = espCharacter.PrimaryPart
	local Inset = GUIService:GetGuiInset();
	local screenPoint, IsVisible = Camera:WorldToScreenPoint(PlayerCFrame.Position)
	--local headPoint, IsVisible = Camera:WorldToScreenPoint(espHead.Position)

    local boxHeightScale = Humanoid.RigType == Enum.HumanoidRigType.R15 and 2000 or 4500

    box.Outline = true
    box.Thickness = .7
    box.Outlinecolor = Color3.fromRGB(255, 255, 255)
	box.color = Color3.fromRGB(255, 255, 255)
	box.Visible = IsVisible and shared.CG_ESP_CONFIG.BoxesEnabled or false
	box.Size = Vector2.new((rootPart.Size.X * 1350) / screenPoint.Z, (rootPart.Size.Y * boxHeightScale) / screenPoint.Z);
	box.Position = Vector2.new(screenPoint.X - box.Size.X / 2, (screenPoint.Y + Inset.Y - box.Size.Y / 2));

    local totalHealth = math.clamp(Humanoid.Health, 0, 100)
    local maxHealth = math.clamp(Humanoid.maxHealth, 0, 100)

    HealthBar.Outline = true
    HealthBar.Thickness = 1
    HealthBar.Outlinecolor = Color3.fromRGB(0, 0, 0)
	HealthBar.Visible = IsVisible and shared.CG_ESP_CONFIG.HealthBarEnabled or false
	HealthBar.Filled = true
	HealthBar.color = Color3.fromRGB(0, 214, 0)
	HealthBar.Size = Vector2.new(2, ((totalHealth / maxHealth) * ((rootPart.Size.Y * boxHeightScale) / screenPoint.Z)))

	HealthBar.Position = Vector2.new((box.Position.X + (box.Size.X - box.Size.X)) - (HealthBar.Size.X * 2.5), box.Position.Y)

	local bodyEffectsFolder = espCharacter:FindFirstChild("BodyEffects")
	local ArmorInstance = bodyEffectsFolder and bodyEffectsFolder:FindFirstChild("Armor")-- For da hood games
	local maxArmor = game.PlaceId == 17108757521 and 130 or 100

	if ArmorInstance then
		ArmorBar.Outline = ArmorInstance.Value > 0 and true or false
		ArmorBar.Thickness = 1
		ArmorBar.Outlinecolor = Color3.fromRGB(0, 0, 0)
		ArmorBar.Visible = IsVisible and shared.CG_ESP_CONFIG.ArmorBarEnabled or false
		ArmorBar.Filled = true
		ArmorBar.color = Color3.fromRGB(0, 140, 255)
		ArmorBar.Size = Vector2.new((ArmorInstance.Value / maxArmor) * (box.Size.X), 2)

		ArmorBar.Position = Vector2.new(box.Position.X, (screenPoint.Y + Inset.Y + box.Size.Y / 2) + ((ArmorBar.Size.Y * 1.6)))
	else
		ArmorBar.Visible = false
	end

	text.Visible = IsVisible and shared.CG_ESP_CONFIG.NametagsEnabled or false
	text.Position = Vector2.new(box.Position.X + (box.Size.X / 2), box.Position.Y - (box.Size.Y / 2) / 10)
end

for _, foundClient in ipairs(Players:GetPlayers()) do
	unloadPlayerESP(foundClient)
end

table.insert(shared.CG_ESP_CONNECTIONS, runService.RenderStepped:Connect(function()
	for _, foundClient in ipairs(Players:GetPlayers()) do
        if foundClient == Player then continue end
		if not foundClient.Character then
			unloadPlayerESP(foundClient)
			continue
		end
		
		updatePlayerESP(foundClient)
	end
end))

table.insert(shared.CG_ESP_CONNECTIONS, Players.PlayerRemoving:Connect(unloadPlayerESP))

return esp_Module
