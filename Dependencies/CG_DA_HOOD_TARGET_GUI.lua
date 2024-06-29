local GUI = game:GetObjects("rbxassetid://17712897650")[1]

local formatNumber = (function (n)
	n = tostring(n)
	return n:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end) -- https://devforum.roblox.com/t/formatting-a-currency-label-to-include-commas/413670/3

shared.current_CG_DA_HOOD_TARGET_UI = shared.current_CG_DA_HOOD_TARGET_UI

if shared.current_CG_DA_HOOD_TARGET_UI then
	shared.current_CG_DA_HOOD_TARGET_UI:Destroy()
	shared.current_CG_DA_HOOD_TARGET_UI = nil
end

shared.current_CG_DA_HOOD_TARGET_UI = GUI

GUI.Parent = game:GetService("CoreGui")

local NOCLIP_MODULE = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/CG_NOCLIP_MODULE.lua", true))()
local FEFLING_FUNCTION = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/FE_FLINGFIX.lua", true))()

local Camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MainEvent = ReplicatedStorage:FindFirstChild("MainEvent")

local topBar = GUI.TopBar
local main = topBar.Main
local opened = true
local tweenService = game:GetService("TweenService")
local interactButton = topBar.interact
local exitButton = topBar.exit
local openSize = main.Size

local Container = main.Container
local ContainerFunctions = Container.ContainerFunctions

local buttonTemplate = ContainerFunctions.ButtonTemplate
local toggleTemplate = ContainerFunctions.ToggleTemplate

local userInputBox = Container.userInput
local AvatarFrame = Container.AvatarFrame
local AvatarImageLabel = AvatarFrame.AvatarImage

local targetsUserLabel = Container.targetsUser
local targetsCashLabel = Container.targetsCash
local targetsCreationDateLabel = Container.targetsCreationDate

local holdingTopBar = false
local autoBagBuyPosition = Vector3.new(-316, 51, -724)

-- External Functions
shared.CG_EXTERNAL_TARGET_GUI_getTool = shared.CG_EXTERNAL_TARGET_GUI_getTool
shared.CG_EXTERNAL_TARGET_GUI_IsDead = shared.CG_EXTERNAL_TARGET_GUI_IsDead
shared.CG_EXTERNAL_TARGET_GUI_IsKnocked = shared.CG_EXTERNAL_TARGET_GUI_IsKnocked
shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc = shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc
shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash = shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash

local getTool = shared.CG_EXTERNAL_TARGET_GUI_getTool
local IsDead = shared.CG_EXTERNAL_TARGET_GUI_IsDead
local IsKnocked = shared.CG_EXTERNAL_TARGET_GUI_IsKnocked
local TeleportFunc = shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc
local getPlayerCash = shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash

local function isAntiCheatBypassed()
	return shared.CG_isAntiCheatBypassed
end

local function getIgnoredFolder()
	return workspace:FindFirstChild("Ignored")
end

local function getItemsDroppedFolder()
	local ignoredFolder = getIgnoredFolder()
	if not ignoredFolder then return end

	return ignoredFolder:FindFirstChild("ItemsDrop")
end

local function getDropFolder()
	local ignoredFolder = getIgnoredFolder()
	if not ignoredFolder then return end

	return ignoredFolder:FindFirstChild("Drop")
end

local function isBagged(plr)
	plr = plr or Player
	if not plr.Character then return end

	return plr.Character:FindFirstChild("Christmas_Sock")
end

local function getShopFolder()
	local ignoredFolder = getIgnoredFolder()
	if not ignoredFolder then return end

	return ignoredFolder:FindFirstChild("Shop")
end

local currentTeleportBodyPosition = nil

local function teleport_func_test(teleportPos) -- I'm trying this method - CG
	if not Player.Character then return end
	if typeof(teleportPos) ~= "Vector3" then return end
	if not isAntiCheatBypassed() then return end

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

-- I've done this in a seperate loadstring because I don't want to bloat the main script and make it hard for me to read and work on.
-- You can use the GUI and main script seperate it's easier

userInputBox.RichText = true

targetsUserLabel.RichText = true
targetsCashLabel.RichText = true
targetsCreationDateLabel.RichText = true

targetsUserLabel.FontFace.Style = Enum.FontStyle.Italic
targetsCashLabel.FontFace.Style = Enum.FontStyle.Italic
targetsCreationDateLabel.FontFace.Style = Enum.FontStyle.Italic

targetsUserLabel.FontFace.Weight = Enum.FontWeight.Bold
targetsCashLabel.FontFace.Weight = Enum.FontWeight.Bold
targetsCreationDateLabel.FontFace.Weight = Enum.FontWeight.Bold

shared.CG_DA_HOOD_TARGET_GUI_FUNCTIONS = {
	setInternelFunctions = function(functionList)
		shared.CG_EXTERNAL_TARGET_GUI_getTool = shared.CG_EXTERNAL_TARGET_GUI_getTool or functionList.getTool
		shared.CG_EXTERNAL_TARGET_GUI_IsDead = shared.CG_EXTERNAL_TARGET_GUI_IsDead or functionList.IsDead
		shared.CG_EXTERNAL_TARGET_GUI_IsKnocked = shared.CG_EXTERNAL_TARGET_GUI_IsKnocked or functionList.IsKnocked
		shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc = shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc or functionList.TeleportFunc
		shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash = shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash or functionList.getPlayerCash

		getTool = shared.CG_EXTERNAL_TARGET_GUI_getTool
		IsDead = shared.CG_EXTERNAL_TARGET_GUI_IsDead
		IsKnocked = shared.CG_EXTERNAL_TARGET_GUI_IsKnocked
		TeleportFunc = shared.CG_EXTERNAL_TARGET_GUI_TeleportFunc
		getPlayerCash = shared.CG_EXTERNAL_TARGET_GUI_getPlayerCash
	end
}

shared.CG_DA_HOOD_TAGET_TOGGLES = {
	ViewPlayer = false,
	AutoBag = false,
	AutoStomp = false,
	AutoKill = false,
	AutoFling = false
}

local function getPlayerFromInput()
	local input = userInputBox.Text:lower()

	if #tostring(input) <= 0 then return end

	local player = nil
	local exactMatch = nil
	local exactMatchFound = false
	local partialMatch = nil
	local partialMatchFound = false

	if not exactMatchFound then
		for _, plr in pairs(game.Players:GetPlayers()) do
			if plr.Name:lower():sub(1, #input) == input or plr.DisplayName:lower():sub(1, #input) == input then
				if exactMatchFound then
					partialMatchFound = true
					partialMatch = plr
				else
					exactMatchFound = true
					exactMatch = plr
				end
			end
		end
	end

	if exactMatchFound then
		return exactMatch
	end

	if partialMatchFound then
		return partialMatch
	end

	return nil
end

local function makeButton(info)
	local info = info or {}
	local toggleName = info.Name or "???"
	local callback = type(info.Callback) == "function" and info.Callback or function() end

	local newButton = buttonTemplate:Clone()
	newButton.RichText = false
	newButton.FontFace.Weight = Enum.FontWeight.Bold
	newButton.FontFace.Style = Enum.FontStyle.Italic

	newButton.Text = toggleName
	newButton.Name = toggleName

	newButton.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)

	newButton.Parent = ContainerFunctions
	newButton.Visible = true
end

local function makeToggle(info)
	local info = info or {}
	local toggleName = info.Name or "???"
	local toggleDefault = type(info.Default) == "boolean" and info.Default or false
	local callback = type(info.Callback) == "function" and info.Callback or function() end
	
	local newToggle = toggleTemplate:Clone()
	newToggle.RichText = false
	newToggle.FontFace.Weight = Enum.FontWeight.Bold
	newToggle.FontFace.Style = Enum.FontStyle.Italic
	
	newToggle.Text = toggleName
	newToggle.Name = toggleName
	
	newToggle:SetAttribute("activated", toggleDefault)
	
	local function update()
		local activeBool = newToggle:GetAttribute("activated")
		tweenService:Create(newToggle.UIStroke, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
			Color = activeBool and Color3.fromRGB(0, 97, 0) or Color3.fromRGB(93, 0, 0)
		}):Play()
		
		task.spawn(callback, activeBool)
	end
	
	update()
	
	newToggle.MouseButton1Click:Connect(function()
		newToggle:SetAttribute("activated", not newToggle:GetAttribute("activated"))
		update()
	end)
	
	newToggle.Parent = ContainerFunctions
	newToggle.Visible = true
end

--[[
makeButton({
	Name = "Bring",
	Callback = function()
		if not Player.Character then return; end;
		local foundTarget = getPlayerFromInput()
		if not foundTarget then return; end;
		if not foundTarget.Character then return end
		if not TeleportFunc or not isAntiCheatBypassed() then return end

		local originalCharacter = Player.Character
		local broughtTarget = false

		while not broughtTarget and originalCharacter == Player.Character do
			task.wait()
		end
	end
})
]]

makeButton({
	Name = "Goto",
	Callback = function()
		local foundTarget = getPlayerFromInput()
		if not foundTarget then return; end;
		if not foundTarget.Character then return end
		if not TeleportFunc or not isAntiCheatBypassed() then return end

		TeleportFunc(foundTarget.Character.PrimaryPart.Position + Vector3.new(0, 0, -2.25))
		Player.Character.PrimaryPart.CFrame = CFrame.new(Player.Character.PrimaryPart.Position, foundTarget.Character.PrimaryPart.Position)
	end
})

makeToggle({
	Name = "View",
	Default = false,
	Callback = function(toggleBool)
		shared.CG_DA_HOOD_TAGET_TOGGLES.ViewPlayer = toggleBool
		
		if not toggleBool then return end
		
		while shared.CG_DA_HOOD_TAGET_TOGGLES.ViewPlayer do
			local foundTarget = getPlayerFromInput()
			if not foundTarget then task.wait(); continue; end;
			if not foundTarget.Character then task.wait(); continue; end;
			
			Camera.CameraSubject = foundTarget.Character
			
			task.wait()
		end
		
		if Player.Character then
			Camera.CameraSubject = Player.Character
		end
	end
})

makeToggle({
	Name = "Auto Kill",
	Default = false,
	Callback = function(toggleBool)
		shared.CG_DA_HOOD_TAGET_TOGGLES.AutoKill = toggleBool

		if not toggleBool then
			return NOCLIP_MODULE.setNoClipEnabled(false)
		end

		NOCLIP_MODULE.setNoClipEnabled(true)

		while shared.CG_DA_HOOD_TAGET_TOGGLES.AutoKill do
			pcall(function()
				if not Player.Character then
					return;
				end;
	
				local foundTarget = getPlayerFromInput()
				if not foundTarget then
					NOCLIP_MODULE.setNoClipEnabled(false)
					return;
				end;
				if not foundTarget.Character then
					NOCLIP_MODULE.setNoClipEnabled(false)
					return;
				end;
	
				if not TeleportFunc or not IsDead or not IsKnocked or not getTool or not isAntiCheatBypassed() then return end
				local fistsTool = getTool("[Knife]") or getTool("Combat")
				if not fistsTool then
					return;
				end;
	
				if IsKnocked(foundTarget) and not IsDead(foundTarget) then
					clearTeleportBodyPos()

					if NOCLIP_MODULE.IsNoclipEnabled() then
						NOCLIP_MODULE.setNoClipEnabled(false)
					end
	
					pcall(function()
						TeleportFunc(foundTarget.Character.UpperTorso.Position)
					end)
					MainEvent:FireServer("Stomp")
	
					pcall(function()
						fistsTool.Parent = Player.Backpack
					end)
				elseif not IsKnocked(foundTarget) and not IsDead(foundTarget) then
					if not NOCLIP_MODULE.IsNoclipEnabled() then
						NOCLIP_MODULE.setNoClipEnabled(true)
					end

					pcall(function()
						teleport_func_test(foundTarget.Character.PrimaryPart.Position + Vector3.new(0, 0, -2.25))
						Player.Character.PrimaryPart.CFrame = CFrame.new(Player.Character.PrimaryPart.Position, foundTarget.Character.PrimaryPart.Position)
					end)
	
					pcall(function()
						fistsTool.Parent = Player.Character
	
						fistsTool:Activate()
					end)
				end
			end)

			task.wait()
		end

		NOCLIP_MODULE.setNoClipEnabled(false)

		clearTeleportBodyPos()
	end
})

makeToggle({
	Name = "Auto Bag",
	Default = false,
	Callback = function(toggleBool)
		shared.CG_DA_HOOD_TAGET_TOGGLES.AutoBag = toggleBool

		if not toggleBool then
			return NOCLIP_MODULE.setNoClipEnabled(false)
		end

		NOCLIP_MODULE.setNoClipEnabled(true)
		
		local teleportedBackToOldPos = false
		local OLD_POS = nil

		while shared.CG_DA_HOOD_TAGET_TOGGLES.AutoBag do
			pcall(function()
				if not Player.Character then return; end;

				local foundTarget = getPlayerFromInput()
				if not foundTarget then
					NOCLIP_MODULE.setNoClipEnabled(false)
					return;
				end;
				if not foundTarget.Character then
					NOCLIP_MODULE.setNoClipEnabled(false)
					return;
				end;
				if not TeleportFunc or not IsDead or not IsKnocked or not getTool or not isAntiCheatBypassed() then return end
		
				if not NOCLIP_MODULE.IsNoclipEnabled() then
					NOCLIP_MODULE.setNoClipEnabled(true)
				end

				OLD_POS = OLD_POS or Player.Character.PrimaryPart.Position
	
				local bagTool = getTool("[BrownBag]")
	
				local shopFolder = getShopFolder()
				if not shopFolder then return; end;
	
				local bagBuyPart = shopFolder:FindFirstChild("[BrownBag] - $27")
				if not bagBuyPart then return; end;
	
				if not isBagged(foundTarget) then
					teleportedBackToOldPos = false
	
					if not bagTool then
						teleport_func_test(autoBagBuyPosition)
	
						pcall(function()
							fireclickdetector(bagBuyPart.ClickDetector, 10)
						end)
					else
						teleport_func_test(foundTarget.Character.PrimaryPart.Position + Vector3.new(0, 0, -2.25))
						Player.Character.PrimaryPart.CFrame = CFrame.new(Player.Character.PrimaryPart.Position, foundTarget.Character.PrimaryPart.Position)
	
						pcall(function()
							bagTool.Parent = Player.Character
							bagTool:Activate()
						end)
					end
				else
					clearTeleportBodyPos()
					if not teleportedBackToOldPos then
						teleportedBackToOldPos = true
	
						TeleportFunc(OLD_POS)
					end
				end
			end)

			task.wait()
		end
		
		NOCLIP_MODULE.setNoClipEnabled(false)
		clearTeleportBodyPos()
	end
})

makeToggle({
	Name = "Auto Fling",
	Default = false,
	Callback = function(toggleBool)
		shared.CG_DA_HOOD_TAGET_TOGGLES.AutoFling = toggleBool
		
		if not toggleBool then return end
		
		local OLDPOS = nil
		
		while shared.CG_DA_HOOD_TAGET_TOGGLES.AutoFling do
			if not isAntiCheatBypassed() or not TeleportFunc then task.wait(); continue; end;
			
			if not Player.Character then task.wait(); continue; end;
		
			local localRoot = Player.Character:FindFirstChild("HumanoidRootPart")
			if not localRoot then task.wait(); continue; end;
			
			OLDPOS = OLDPOS or localRoot.Position
			
			local foundTarget = getPlayerFromInput()
			if not foundTarget then task.wait(); continue; end;
			if not foundTarget.Character then task.wait(); continue; end;
					
			FEFLING_FUNCTION(foundTarget.Name)
			
			task.wait()
		end
		
		if Player.Character then
			local localRoot = Player.Character:FindFirstChild("HumanoidRootPart")
			if not localRoot then return end
			
			localRoot.Velocity = Vector3.new(0, 0, 0)
			localRoot.RotVelocity = Vector3.new(0, 0, 0)
			
			if OLDPOS then
				TeleportFunc(OLDPOS)
			end
		end

	end
})

interactButton.MouseButton1Down:Connect(function()
	holdingTopBar = true
end)

interactButton.MouseButton1Up:Connect(function()
	holdingTopBar = false
end)

exitButton.MouseButton1Click:Connect(function()
	shared.current_CG_DA_HOOD_TARGET_UI:Destroy()
	shared.current_CG_DA_HOOD_TARGET_UI = nil
end)

task.spawn(function()
	while GUI and GUI.Parent ~= nil do
		
		if holdingTopBar then
			local X,Y = (Mouse.X * 2) / 1.5, Mouse.Y + 10
			
			tweenService:Create(topBar, TweenInfo.new(.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0, X, 0, Y)
			}):Play()
		end
		
		local foundTarget = getPlayerFromInput()
		if not foundTarget then
			AvatarImageLabel.Image = "rbxassetid://0"
			targetsUserLabel.Text = `Username:`
			targetsCashLabel.Text = `Cash:`
			targetsCreationDateLabel.Text = `Creation Date:`
			task.wait()
			continue
		end

		local avatarImage = game.Players:GetUserThumbnailAsync(foundTarget.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		AvatarImageLabel.Image = avatarImage

		targetsUserLabel.Text = `Username: <font color="rgb(255, 255, 255)">{foundTarget.Name}</font>`
		
		if type(getPlayerCash) == "function" then
			local targetsCash = getPlayerCash(foundTarget)
			targetsCashLabel.Text = `Cash: <font color="rgb(52, 235, 76)">${formatNumber(targetsCash)}</font>`
		end

		local DT = DateTime.fromUnixTimestamp(os.time() - 86400 * foundTarget.AccountAge)
		local Day = tonumber(DT:FormatUniversalTime("D", "en-us"))
		local Month = tonumber(DT:FormatUniversalTime("MM", "en-us"))
		local Year = tonumber(DT:FormatUniversalTime("YYYY", "en-us"))

		local targetsCreationDate = os.date("%m/%d/%Y", foundTarget.AccountAge)
		targetsCreationDateLabel.Text = `Creation Date: <font color="rgb(255, 255, 255)">{Day}/{Month}/{Year}</font>`
	end
end)