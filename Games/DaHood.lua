task.spawn(function()
    repeat
        task.wait()
    until game:IsLoaded()

    local ClonedPlaceId = game.PlaceId
    local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/NOTI_LIB.lua", true))()
    
    NotiLib.new("info", "Da Hood", "join The discord server (copied to clipboard), https://discord.gg/DAssqn8XET")
    NotiLib.new("info", "Da Hood", "Da Hood Script Loading")
    
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/Roblox-UI-Libs/main/xsx%20Lib/xsx%20Lib%20Source.lua", true))()

    -- AIM VIEW MODULE --
    local CG_AIM_VIEW_LIB = shared.CG_HUB_DEPENDENCIES.CG_AIM_VIEW_LIB

    -- ESP MODULE --
    local CG_ESP_LIB = shared.CG_HUB_DEPENDENCIES.CG_ESP_LIB

    -- FLY MODULE --
    local CG_FLY_LIB = shared.CG_HUB_DEPENDENCIES.CG_FLY_LIB

    -- LOW GFX MODULE --
    local CG_LOW_GFX_LIB = shared.CG_HUB_DEPENDENCIES.CG_LOW_GFX_LIB
    
    local Camera = workspace.CurrentCamera

    shared.CG_DA_HOOD_CONNECTIONS = shared.CG_DA_HOOD_CONNECTIONS or {}

    for _, signalConnection in ipairs(shared.CG_DA_HOOD_CONNECTIONS) do
        pcall(signalConnection.Disconnect, signalConnection)
    end
    
    table.clear(shared.CG_DA_HOOD_CONNECTIONS)

    if shared.CG_FOV_CIRCLE_VISUAL then
        pcall(shared.CG_FOV_CIRCLE_VISUAL.Remove, shared.CG_FOV_CIRCLE_VISUAL)
        shared.CG_FOV_CIRCLE_VISUAL = nil
    end

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

    local da_hood_staff_group_ids = {
        8068202
    }

    local window = Library:New({
        Name = "CG's Da Hood Script",
        Theme = "Dark",
        Accent = Color3.fromRGB(50, 100, 255),
        Bind = Enum.KeyCode.V
    })

    shared.CG_CURRENT_WINDOW = window
    
    -- Bro I deadass forgot I can just modify the actual lib source to match my current shit sobbing

    local release_Dev_Features = false
    
    local PlayerTab = window:Page({Name = "Player"})
    local AimTab = window:Page({Name = "Aim"})
    local VisualsTab = window:Page({Name = "Visuals"})
    local MiscTab = window:Page({Name = "Misc"})

    local MiscSection = MiscTab:Section({Name = "Main", Side = "Left"})
    local PlayerSection = PlayerTab:Section({Name = "Main", Side = "Left"})
    local AimSectionLeft = AimTab:Section({Name = "Main", Side = "Left"})
    local VisualsSectionLeft = VisualsTab:Section({Name = "Main", Side = "Left"})

    local autoFarmToggles = {}
    local autoLettuceFarmTeleportPosition = Vector3.new(-81, 23, -633)
    local autoBuyMaskTeleportPosition = Vector3.new(110, 23, -487)

    shared.CG_DA_HOOD_GRENADE_NUKING = shared.CG_DA_HOOD_GRENADE_NUKING or false

    local isPlayerLoadedBool = false
    local teleportLocations = {
        ["UFO"] = Vector3.new(81, 139, -658),
        ["Uphill Gunz"] = Vector3.new(481, 48, -622),
        ["Uphill Food"] = Vector3.new(298, 49, -613),
        ["Downhill Gunz"] = Vector3.new(-580, 8, -735),
        ["Downhill Food"] = Vector3.new(-334, 24, -298),
        ["Bank"] = Vector3.new(-461, 39, -280),
        ["School"] = Vector3.new(-594, 22, 229),
        ["Jeff's Taco's"] = Vector3.new(585, 51, -480),
        ["Jail / Prison"] = Vector3.new(-293, 22, -112),
        ["Military Base"] = Vector3.new(37, 25, -873),
        ["Police Station"] = Vector3.new(-266, 22, -95),
        ["Hood Fitness"] = Vector3.new(-75, 23, -633),
        ["Phone Store"] = Vector3.new(-119, 22, -982),
        ["Da Boxing Club"] = Vector3.new(-253, 23, -1121),
        ["Da Theatre"] = Vector3.new(-1006, 25, -142),
        ["Da Casino"] = Vector3.new(-861, 22, -130),
        ["Firestation"] = Vector3.new(-151, 54, -92),
        ["Nightclub"] = Vector3.new(-257, -6, -389),
        ["TreeHouse"] = Vector3.new(-74, 55, -257)
    }
    
    local targetParts = {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "HumanoidRootPart"
    }
    
    local notiMessages = {
        ["NotRealDH"] = "This is not real Da Hood, some features may not work!",
        ["WaitingForPlayerToLoad"] = "Waiting for player to load in!",
        ["PlayerLoadedIn"] = "Player loaded!",
        ["BypassingAntiCheat"] = "Attempting to bypass anti cheat!",
        ["BypassedAntiCheat"] = "Anti cheat bypassed!",
    }
    
    local Services = {
        Players = game:GetService("Players"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        VirtualInputManager = game:GetService("VirtualInputManager"),
        HttpService = game:GetService("HttpService"),
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        TweenService = game:GetService("TweenService"),
        TeleportService = game:GetService("TeleportService")
    }

    local MainEvent = Services.ReplicatedStorage:FindFirstChild("MainEvent")
    
    local Vars = {
        Player = Services.Players.LocalPlayer
    }
    
    Vars.PlayerMouse = Vars.Player:GetMouse()
    
    shared.CG_DA_HOOD_BACKUP_DATA = shared.CG_DA_HOOD_BACKUP_DATA or {
        HipHeight = nil
    }

    shared.CG_isAntiCheatBypassed = shared.CG_isAntiCheatBypassed or false
    local currentAimLockTarget = nil

    shared.CG_DA_HOOD_CONFIG_TABLE = {
        NoPlayerSlowDown = false,
        fly_toggle = false,
        da_hood_staff_checker = false,
        low_gfx_toggle = false,

        AntiLockBool = false,
        AntiLockResolveBool = false,
        AntiFlingBool = false,
        AntiStompBool = false,

        AutoBlockPunchesBool = false,
        AutoPickupMoneyBool = false,
        AutoStompBool = false,
        AutoLettuceBool = false,
        auto_mask_toggle = false,

        Speed_Macro_Speed_Amount = 200,
        SpeedMacroToggle = false,
        holdingSpeedMacroKey = false,

        CHAT_SPY_BOOL = false,
        RGB_THEME_BOOL = false,

        AUTO_DROP_CASH_AMOUNT = 10000,
        AUTO_DROP_CASH_BOOL = false,

        -- AIM STUFF --
        aim_prediction_amount = 14,
        AimViewBool = false,
        AimLockKnockedCheckBool = false,
        IsAttemptingToLock = false,
        AimLockBool = false,
        defaultTargetPart = targetParts[1],
        aimlockTargetPart = targetParts[1],
        aimsmoothness = 1,
        stickyAimLockBool = false,
        aim_prediction_mode = "Auto",
        aim_prediction_type = "Velocity",

        show_fov_bool = false,
        FOV_RADIUS = 75,
    }

    local VisualfovCircle = Drawing.new("Circle")
    VisualfovCircle.Thickness = 2
    VisualfovCircle.Transparency = 1
    VisualfovCircle.Visible = false
    VisualfovCircle.Color = Color3.fromRGB(255, 255, 255)
    VisualfovCircle.Filled = false
    VisualfovCircle.Radius = shared.CG_DA_HOOD_CONFIG_TABLE.FOV_RADIUS
    shared.CG_FOV_CIRCLE_VISUAL = VisualfovCircle
    
    Vars.Character = Vars.Player.Character or Vars.Player.CharacterAdded:Wait()
    
    local function makeConnection(event, callback)
        local connection = event:Connect(callback)
    
        table.insert(shared.CG_DA_HOOD_CONNECTIONS, connection)
    
        return connection
    end

    local function disableOtherToggles(togglesTable, excludedToggleName)
        for _, toggle in ipairs(togglesTable) do
            if type(toggle) ~= "table" then continue end
            if toggle.name:lower() == tostring(excludedToggleName):lower() then continue end

            toggle:Set(false)
        end
    end

    local real_da_hood_game_place_ids = {
        2788229376,
        16033173781,
        7213786345
    }

    local function isRealDaHoodGame()
        local isRealGame = false

        for _, placeId in ipairs(real_da_hood_game_place_ids) do
            if ClonedPlaceId == placeId then
                isRealGame = true
                break
            end
        end

        return isRealGame
    end

    local function isFoodTool(tool)
        if typeof(tool) ~= "Instance" then return false end

        for _, OBJ in ipairs(tool:GetDescendants()) do
            if OBJ.Name:lower() == "drink" or OBJ.Name:lower() == "eat" then
                return true
            end
        end

        return false
    end

    local function bypassAntiCheat()
        if not isRealDaHoodGame() then
            shared.CG_isAntiCheatBypassed = true
            return
        end

        local Character = Vars.Character
        if not Character then return end

        for _, OBJ in ipairs(Character:GetChildren()) do
            if not OBJ:IsA("Script") then continue end

            local HasLocalScript = OBJ:FindFirstChildWhichIsA("LocalScript")
            if not HasLocalScript then continue end

            HasLocalScript:Destroy()
            OBJ:Destroy()

            task.wait(1)
            shared.CG_isAntiCheatBypassed = true
        end
    end

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

    local function isAntiCheatDisabled()
        return shared.CG_isAntiCheatBypassed
    end

    CG_FLY_LIB.SetAntiCheatBypassedFunction(isAntiCheatDisabled)
    
    if not isRealDaHoodGame() then
        NotiLib.new("warning", "Da Hood", notiMessages.NotRealDH)
    end
    
    local function isPlayerLoadedCheck()
        if not Vars.Character then return false end
        
        if not isRealDaHoodGame() then
            return true
        end

        return Vars.Character:FindFirstChild("FULLY_LOADED_CHAR") and true or false
    end

    local function getPhoneTool()
        local backPackFolder = Vars.Player:FindFirstChild("Backpack")
        if not backPackFolder then return end
        
        local characterTool = Vars.Character and Vars.Character:FindFirstChild("[Phone]")

        return characterTool or backPackFolder:FindFirstChild("[Phone]")
    end

    local function getDataFolder(plr)
        plr = plr or Vars.Player

        return plr:FindFirstChild("DataFolder")
    end

    local function getPlayerCash(plr)
        plr = plr or Vars.Player
        local DataFolder = getDataFolder(plr)
        if not DataFolder then return 0 end

        local CurrencyInstance = DataFolder:FindFirstChild("Currency")
        if not CurrencyInstance then return 0 end

        return tonumber(CurrencyInstance.Value)
    end

    local function getTool(toolName)
        local backPackFolder = Vars.Player:FindFirstChild("Backpack")
        if not backPackFolder then return end

        if not Vars.Character then return end
        
        local characterTool = Vars.Character and Vars.Character:FindFirstChild(toolName)

        return characterTool or backPackFolder:FindFirstChild(toolName)
    end
    
    local function resetHipheight()
        if not isPlayerLoadedCheck() then return end
        if not Vars.Character then return end
    
        local Humanoid = Vars.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end
    
        local hipHeight = calculateHipHeight(Vars.Character)
    
        Humanoid.HipHeight = hipHeight
    end

    local function IsPlayerStaff(plr)
        if not plr then return false end

        local isStaff = false
        
        for da_hood_staff_group_id_index = 1, #da_hood_staff_group_ids do
            if isStaff then break end

            isStaff = plr:IsInGroup(da_hood_staff_group_ids[da_hood_staff_group_id_index])
        end

        return isStaff
    end

    makeConnection(Services.Players.PlayerAdded, function(newPlayer)
        if not shared.CG_DA_HOOD_CONFIG_TABLE.da_hood_staff_checker then return end

        local isStaff = IsPlayerStaff(newPlayer)

        if isStaff then
            NotiLib.new("info", "Da Hood", newPlayer.Name .. " IS A STAFF MEMBER !!!!")
        end
    end)

    makeConnection(Vars.Player.CharacterAdded, function(newChar)
        shared.CG_DA_HOOD_GRENADE_NUKING = false
        isPlayerLoaded = false
        shared.CG_isAntiCheatBypassed = false
        Vars.Character = newChar

        local characterHumanoid = Vars.Character:WaitForChild("Humanoid", 60)
        if not characterHumanoid then 
            return Vars.Player:Kick("CG's Da Hood Script failed to load, rejoin and try again!")
        end
    
        NotiLib.new("info", "Da Hood", notiMessages.BypassingAntiCheat)

        local didPlayerDie = false

        makeConnection(characterHumanoid.Died, function()
            isPlayerLoaded = false
            shared.CG_isAntiCheatBypassed = false
        end)

        repeat
            bypassAntiCheat()
            task.wait()
        until shared.CG_isAntiCheatBypassed or didPlayerDie
    
        if not didPlayerDie then
            NotiLib.new("info", "Da Hood", notiMessages.BypassedAntiCheat)
        end

        repeat
            task.wait()
        until isPlayerLoadedCheck() or didPlayerDie
    
        if not didPlayerDie then
            isPlayerLoaded = true
        end
    end)
    
    NotiLib.new("info", "Da Hood", notiMessages.BypassingAntiCheat)

    repeat
        bypassAntiCheat()
        task.wait()
    until shared.CG_isAntiCheatBypassed

    NotiLib.new("info", "Da Hood", notiMessages.BypassedAntiCheat)

    NotiLib.new("info", "Da Hood", notiMessages.WaitingForPlayerToLoad)

    repeat
        task.wait()
    until isPlayerLoadedCheck()
    
    NotiLib.new("success", "Da Hood", notiMessages.PlayerLoadedIn)
    
    isPlayerLoaded = true
    
    resetHipheight()
    
    -- CUSTOM FUNCTIONS --
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

    local function getShopFolder()
        local ignoredFolder = getIgnoredFolder()
        if not ignoredFolder then return end

        return ignoredFolder:FindFirstChild("Shop")
    end

    local function getBodyEffectsFolder(plr)
        plr = plr or Vars.Player
        if not plr.Character then return end
    
        return plr.Character:FindFirstChild("BodyEffects")
    end
    
    local function getMovementFolder(plr)
        plr = plr or Vars.Player

        local BodyEffectsFolder = getBodyEffectsFolder()
        if not BodyEffectsFolder then return end
        
        return BodyEffectsFolder:FindFirstChild("Movement")
    end

    local function isKnocked(plr)
        local BodyEffectsFolder = getBodyEffectsFolder(plr)
        if not BodyEffectsFolder then return end

        local KOBool = BodyEffectsFolder:FindFirstChild("K.O")
        if not KOBool then return end

        return KOBool.Value
    end
    
    local function isDead(plr)
        local BodyEffectsFolder = getBodyEffectsFolder(plr)
        if not BodyEffectsFolder then return end

        local DeadBool = BodyEffectsFolder:FindFirstChild("Dead")
        if not DeadBool then return end

        return DeadBool.Value
    end

    local function teleportFunc(teleportPos)
        if not isPlayerLoadedCheck() then return end
        if not Vars.Character or typeof(teleportPos) ~= "Vector3" then return end
    
        local humanoidRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
    
        humanoidRootPart.CFrame = CFrame.new(teleportPos) * CFrame.new(0, humanoidRootPart.Size.Y / 2, 0)
    end

    local function custom_fireclickdetector(clickPart)
        if not Vars.Character then return end

        local currentPosition = Vars.Character.PrimaryPart.Position

        if typeof(clickPart) ~= "Instance" or not clickPart:IsA("BasePart") then return end

        local detector = clickPart:FindFirstChildWhichIsA("ClickDetector")
        if not detector then return end

        local oldCameraCFrame = Camera.CFrame

        Vars.Player.CameraMode = Enum.CameraMode.LockFirstPerson

        teleportFunc(clickPart.Position)

        Camera.CFrame = CFrame.new(Camera.CFrame.Position, clickPart.Position)

        local screenPosition, onScreen = Camera:WorldToScreenPoint(clickPart.Position)

        Services.VirtualInputManager:SendMouseButtonEvent(screenPosition.X, screenPosition.Y, 0, true, game, 1)
        Services.VirtualInputManager:SendMouseButtonEvent(screenPosition.X, screenPosition.Y, 0, false, game, 1)

        task.wait(.01)

        teleportFunc(currentPosition)

        Vars.Player.CameraMode = Enum.CameraMode.Classic
    end

    local function getPlayerClosestToMouse(checkKnocked)
        local closestPlayer = nil
        local closestDistance = math.huge

        for _, Player in ipairs(Services.Players:GetPlayers()) do
            if Player == Vars.Player then continue end

            if checkKnocked then
                if isKnocked(Player) then
                    continue
                end
            end

            local Character = Player.Character
            if not Character then continue end

            local CharacterPrimaryPart = Character.PrimaryPart
            if not CharacterPrimaryPart then continue end

            local _, IsOnScreen =  Camera:WorldToScreenPoint(CharacterPrimaryPart.Position)

            local distance = (Vars.PlayerMouse.Hit.p - CharacterPrimaryPart.Position).Magnitude
            if distance < closestDistance and IsOnScreen then
                closestDistance = distance
                closestPlayer = Player
            end
        end

        return closestPlayer
    end

    local function getPlayerClosestToFOV_RADIUS(checkKnocked)
        local closestPlayer = nil
        local closestDistance = shared.CG_DA_HOOD_CONFIG_TABLE.FOV_RADIUS

        for _, Player in ipairs(Services.Players:GetPlayers()) do
            if Player == Vars.Player then continue end

            if checkKnocked then
                if isKnocked(Player) then
                    continue
                end
            end

            local Character = Player.Character
            if not Character then continue end

            local CharacterPrimaryPart = Character.PrimaryPart
            if not CharacterPrimaryPart then continue end

            local OnScreenPosition, IsOnScreen = Camera:WorldToScreenPoint(CharacterPrimaryPart.Position)
            OnScreenPosition = Vector2.new(OnScreenPosition.X, OnScreenPosition.Y)

            local distance = (VisualfovCircle.Position - OnScreenPosition).Magnitude

            if distance < closestDistance and IsOnScreen then
                closestDistance = distance
                closestPlayer = Player
            end
        end

        return closestPlayer
    end

    local function DA_HOOD_PREDICTION(targetPlr, targetPart)
        local gameClientStats = stats()
        local gameClientNetwork = gameClientStats.Network
        local ServerStatsItem = gameClientNetwork.ServerStatsItem
        local gameClientPing = tostring(ServerStatsItem["Data Ping"]:GetValueString()):split(" ")[1]
        local PlayerPing = tonumber(gameClientPing) or 40
    
        if not Vars.Character then return end
    
        local foundTargetPart = targetPlr.Character and targetPlr.Character:FindFirstChild(targetPart)
        if not foundTargetPart then return end
    
        local targetPosition = foundTargetPart.Position
        if not targetPosition then return end

        if shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_mode == "Manual" then
            local targetPartVelocity = targetPlr.Character.PrimaryPart.AssemblyLinearVelocity

            if shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockResolveBool then
                local patchedTargetVelocity = Vector3.new(targetPartVelocity.X, math.clamp(targetPartVelocity.Y, -15, 15), targetPartVelocity.Z)
                targetPartVelocity = patchedTargetVelocity
            end

            local Distance = (Vars.Character.HumanoidRootPart.Position - targetPosition).Magnitude
            local Time = Distance / PlayerPing
            local PredictedPosition = targetPosition + targetPartVelocity * Time * ((shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_amount / 1000) * 20)

            return PredictedPosition
        end
    
        if shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_type == "Velocity" then
            local targetPartVelocity = targetPlr.Character.PrimaryPart.AssemblyLinearVelocity

            if shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockResolveBool then
                local patchedTargetVelocity = Vector3.new(targetPartVelocity.X, math.clamp(targetPartVelocity.Y, -15, 15), targetPartVelocity.Z)
                targetPartVelocity = patchedTargetVelocity
            end

            local TargetDistance = (targetPosition - Camera.CFrame.Position).Magnitude
        
            local localPlayerVelocity = Vars.Character.PrimaryPart.AssemblyLinearVelocity
        
            local Bulletspeed = 2000
            local speedFactor = TargetDistance / math.abs(Bulletspeed)
            if not speedFactor then return end
        
            local gravity = 1--math.abs(workspace.Gravity)
            local timeYeah = TargetDistance / math.abs(Bulletspeed)
            if not timeYeah then return end
        
            local pingInSeconds = PlayerPing / 1000
        
            targetPosition = targetPosition + targetPartVelocity * (speedFactor + pingInSeconds)
            targetPosition = targetPosition - localPlayerVelocity * speedFactor
            targetPosition = targetPosition + Vector3.new(0, 0.5 * gravity * timeYeah * timeYeah, 0)

            return targetPosition
        end

        return targetPosition
    end

    local function antiLock_VERSION_1()
        if not isPlayerLoadedCheck() then return end
        if not Vars.Character then return end
    
        local humanoidRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
    
        local Humanoid = Vars.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end
        
        local oldRootVelocity = humanoidRootPart.AssemblyLinearVelocity
    
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(oldRootVelocity.X, -100, oldRootVelocity.Z)
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(oldRootVelocity.X, oldRootVelocity.Y, oldRootVelocity.Z)
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(oldRootVelocity.X, -100, oldRootVelocity.Z)

        Humanoid.HipHeight = 3.55
    end
    
    local function antiLock_VERSION_2()
        if not isPlayerLoadedCheck() then return end
        if not Vars.Character then return end
    
        local humanoidRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
    
        local Humanoid = Vars.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end
        
        local oldRootVelocity = humanoidRootPart.AssemblyLinearVelocity
        Humanoid.HipHeight = 270
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(oldRootVelocity.X, -5000, oldRootVelocity.Z)
        humanoidRootPart.AssemblyLinearVelocity = oldRootVelocity
        Humanoid.HipHeight = 270
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(oldRootVelocity.X, -5000, oldRootVelocity.Z)
        Humanoid.HipHeight = 270
    end

    local function antiFling()
        for _, Player in ipairs(Services.Players:GetPlayers()) do
            if Player == Vars.Player then continue end
    
            local Character = Player.Character
            if not Character then continue end
            if not Character.PrimaryPart then continue end
    
            if Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if not Part:IsA("BasePart") then continue end

                    Part.CanCollide = false
                    Part.Velocity = Vector3.new(0, 0, 0)
                    Part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    Part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                end
            end
            
        end
    end

    makeConnection(Services.RunService.RenderStepped, function()
        if not VisualfovCircle then return end

        local mosuePosX, mosuePosY = Services.UserInputService:GetMouseLocation().X, Services.UserInputService:GetMouseLocation().Y
        VisualfovCircle.Radius = shared.CG_DA_HOOD_CONFIG_TABLE.FOV_RADIUS
        VisualfovCircle.Position = Vector2.new(mosuePosX, mosuePosY)
    end)
    
    -- PLAYER TAB --
    PlayerSection:Toggle({
        Name = "Fly",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.fly_toggle,
        flag = "playerflyflag",
        Callback = function()
            CG_FLY_LIB.EnableAndDisableFly()
        end
    })

    PlayerSection:Toggle({
        Name = "Auto Block",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AutoBlockPunchesBool,
        flag = "autoblockflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AutoBlockPunchesBool = toggleBool

            if not toggleBool then return end

            task.spawn(function()
                local didBlock = false
                while shared.CG_DA_HOOD_CONFIG_TABLE.AutoBlockPunchesBool do
                    local FoundPlayerAttacking = false

                    for _, Player in ipairs(Services.Players:GetPlayers()) do
                        if Player == Vars.Player then continue end
                        if not Vars.Player.Character then continue end

                        local Character = Player.Character
                        if not Character then continue end

                        local myRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
                        local targetRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if not myRootPart or not targetRootPart then continue end

                        local BodyEffectsFolder = getBodyEffectsFolder(Player)
                        if not BodyEffectsFolder then continue end

                        local attackingBoolInstance = BodyEffectsFolder:FindFirstChild("Attacking")
                        if not attackingBoolInstance then continue end

                        local playerTool = Character:FindFirstChildWhichIsA("Tool")

                        if attackingBoolInstance.Value and not isFoodTool(playerTool) then
                            local targetPosition = targetRootPart.Position
                            local myPosition = myRootPart.Position

                            local distance = (targetPosition - myPosition).Magnitude
                            if distance <= 10 then
                                FoundPlayerAttacking = true
                            end
                        end
                    end

                    if FoundPlayerAttacking then
                        didBlock = true
                        MainEvent:FireServer("Block", true)
                    else
                        if didBlock then
                            didBlock = false
                            MainEvent:FireServer("Block", false)
                        end
                    end
                    
                    task.wait()
                end
            end)
        end
    })

    PlayerSection:Toggle({
        Name = "Auto Mask",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.auto_mask_toggle,
        flag = "automaskflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.auto_mask_toggle = toggleBool

            if not toggleBool then return end

            task.spawn(function()
                local originalPosition = nil

                while shared.CG_DA_HOOD_CONFIG_TABLE.auto_mask_toggle do
                    if CG_FLY_LIB.IsFlying() then task.wait(); continue; end;
                    if not Vars.Character then task.wait(); continue; end;

                    local shopFolder = getShopFolder()
                    if not shopFolder then task.wait(); continue; end

                    local maskBuyPart = shopFolder:FindFirstChild("[Surgeon Mask] - $27")
                    if not maskBuyPart then task.wait(); continue; end
                    
                    local playerHasMask = Vars.Character:FindFirstChild("In-gameMask")

                    if not playerHasMask and Vars.Character.PrimaryPart then
                        originalPosition = originalPosition or Vars.Character.PrimaryPart.Position
                        local maskTool = getTool("[Mask]")
                        if not maskTool then
                            teleportFunc(maskBuyPart and maskBuyPart:FindFirstChild("Head") and maskBuyPart.Head.Position or autoBuyMaskTeleportPosition)
                            local maskClickDetector = maskBuyPart:FindFirstChildWhichIsA("ClickDetector")
                            
                            if maskClickDetector then
                                fireclickdetector(maskClickDetector, 15)
                            end
                            task.wait(.15);
                            continue;
                        end

                        pcall(function()
                            maskTool.Parent = Vars.Character
                            maskTool:Activate()
                            maskTool.Parent = Vars.Player:FindFirstChild("Backpack")
                        end)

                        teleportFunc(originalPosition)
                        originalPosition = nil

                        task.wait(1.15)
                    end

                    task.wait()
                end
            end)
        end
    })

    PlayerSection:Toggle({
        Name = "Speed Macro",
        Default = false,
        flag = "speedMacroFlag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.SpeedMacroToggle = toggleBool

            if not toggleBool then return end

            task.spawn(function()
                local bodyVelocity = Instance.new("BodyVelocity")

                while shared.CG_DA_HOOD_CONFIG_TABLE.SpeedMacroToggle do
                    if CG_FLY_LIB.IsFlying() then
                        if bodyVelocity then
                            pcall(bodyVelocity.Destroy, bodyVelocity)
                        end

                        task.wait();
                        continue;
                    end;
                    if not isAntiCheatDisabled() then task.wait(); continue; end;
                    if not Vars.Character then task.wait(); continue; end;
                    if not bodyVelocity then 
                        bodyVelocity = Instance.new("BodyVelocity")
                        task.wait()
                        continue;
                    end;

                    local Humanoid = Vars.Character:FindFirstChildWhichIsA("Humanoid")
                    if not Humanoid then task.wait(); continue end;

                    local rotationVelocity = Vars.Character.PrimaryPart.AssemblyAngularVelocity

                    if rotationVelocity.Magnitude >= 12 then
                        Vars.Character.PrimaryPart.Velocity = Vector3.new()
                        Vars.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new()

                        Vars.Character.PrimaryPart.RotVelocity = Vector3.new()
                        Vars.Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new()
                    end

                    if not shared.CG_DA_HOOD_CONFIG_TABLE.holdingSpeedMacroKey then
                        bodyVelocity.Velocity = Vector3.new()
                        bodyVelocity.Parent = nil
                        task.wait()
                        continue
                    end

                    bodyVelocity.MaxForce = Vector3.new(9e9, 0, 9e9)
                    bodyVelocity.Velocity = Humanoid.MoveDirection * shared.CG_DA_HOOD_CONFIG_TABLE.Speed_Macro_Speed_Amount
                    bodyVelocity.Parent = Vars.Character.PrimaryPart

                    task.wait()
                end

                if bodyVelocity then
                    pcall(bodyVelocity.Destroy, bodyVelocity)
                end
            end)
        end,
    })

    PlayerSection:Toggle({
        Name = "No Slowdown",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.NoPlayerSlowDown,
        flag = "noPlayerSlowdownFlag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.NoPlayerSlowDown = toggleBool
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.NoPlayerSlowDown do
                    local movementFolder = getMovementFolder()
                    if not movementFolder then task.wait() continue end
    
                    for _, OBJ in ipairs(movementFolder:GetChildren()) do
                        pcall(OBJ.Destroy, OBJ)
                    end
    
                    task.wait()
                end
            end)
        end,
    })
    
    PlayerSection:Toggle({
        Name = "Anti Fling",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AntiFlingBool,
        flag = "antiFlingFlag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AntiFlingBool = toggleBool
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AntiFlingBool do
                    antiFling()
    
                    task.wait()
                end
            end)
        end,
    })

    PlayerSection:Toggle({
        Name = "Anti Stomp",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AntiStompBool,
        flag = "antistompflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AntiStompBool = toggleBool
            
            if not toggleBool then return end

            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AntiStompBool do
                    if not Vars.Character then task.wait(); continue; end;
                    
                    local Humanoid = Vars.Character:FindFirstChildWhichIsA("Humanoid")

                    if isKnocked(Vars.Player) and not isDead(Vars.Player) and Humanoid then
                        Humanoid:TakeDamage(9e9)
                    end

                    task.wait()
                end
            end)
        end
    })
    
    if isRealDaHoodGame() then
        PlayerSection:Button({
            Name = "Unlock Animations",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/DaHoodAnimationUnlocker.lua", true))()
            end
        })

        PlayerSection:Button({
            Name = "Collect Dropped Items",
            Callback = function()
                if CG_FLY_LIB.IsFlying() then return end
                
                local itemsDroppedFolder = getItemsDroppedFolder()
                if not itemsDroppedFolder then return end

                for _, OBJ in ipairs(itemsDroppedFolder:GetChildren()) do
                    if not OBJ:IsA("BasePart") then continue end

                    local hasTool = OBJ:FindFirstChildWhichIsA("Tool")
                    if not hasTool then continue end

                    teleportFunc(OBJ.Position)

                    task.wait(.15)
                end
            end
        })

        PlayerSection:Button({
            Name = "Call all",
            Callback = function()
                if not MainEvent or not Vars.Character then return end

                local phoneTool = getPhoneTool()
                if not phoneTool then return end

                local backPackFolder = Vars.Player:FindFirstChild("Backpack")
                if not backPackFolder then return end

                for _, Player in ipairs(Services.Players:GetPlayers()) do
                    if Player == Vars.Player then continue end

                    phoneTool.Parent = Vars.Character

                    MainEvent:FireServer("PhoneCall", Player.Name)

                    task.wait(.1)
                    phoneTool.Parent = backPackFolder
                end
            end
        })
    end

    PlayerSection:Button({
        Name = "Equip All Tools",
        Callback = function()
            if not Vars.Character then return end

            local backPackFolder = Vars.Player:FindFirstChild("Backpack")
            if not backPackFolder then return end

            for _, OBJ in ipairs(backPackFolder:GetChildren()) do
                if not OBJ:IsA("Tool") then continue end
                
                OBJ.Parent = Vars.Character

                task.wait(.1)
            end
        end
    })

    local PlayerSectionRight = PlayerTab:Section({Name = "Extra", Side = "Right"})
    PlayerSectionRight:Keybind({
        Name = "Speed Macro Keybind",
        KeybindName = "Speed Macro Keybind",
        Default = Enum.KeyCode.Q,
        Mode = "Hold",
        flag = "SpeedMacroKeybindFlag",
        Callback = function(Keybind)
            shared.CG_DA_HOOD_CONFIG_TABLE.holdingSpeedMacroKey = not shared.CG_DA_HOOD_CONFIG_TABLE.holdingSpeedMacroKey
        end,
    })

    PlayerSectionRight:Slider({
        Name = "Macro Speed",
        Minimum = 10,
        Maximum = 1000,
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.Speed_Macro_Speed_Amount,
        flag = "playermacrospeedflag",
        Callback = function(Slidervalue)
            shared.CG_DA_HOOD_CONFIG_TABLE.Speed_Macro_Speed_Amount = Slidervalue
        end
    })

    PlayerSectionRight:Slider({
        Name = "Fly Speed",
        Minimum = 0,
        Maximum = 100,
        Default = 5,
        flag = "playerflyspeedflag",
        Callback = function(Slidervalue)
            CG_FLY_LIB.SetFlySpeed(Slidervalue)
        end
    })

    -- TELEPORTS TAB --
    --if isRealDaHoodGame() then
        local TeleportsTab = window:Page({Name = "Teleports"})
        local TeleportsSection = TeleportsTab:Section({Name = "Main", Side = "Left"})
        for teleportName, teleportPosition in pairs(teleportLocations) do
            TeleportsSection:Button({
                Name = teleportName,
                Callback = function()
                    return pcall(teleportFunc, teleportPosition)
                end
            })
        end

        if release_Dev_Features then
            local shopFolder = getShopFolder()
            if shopFolder then
                local GameItemsTab = window:Page({Name = "Weapon Buying"})
                local alreadyFoundItems = {}

                for _, item in pairs(shopFolder:GetChildren()) do
                    local itemName = item.Name:match("%[(.-)%]")
                    if not itemName then continue end

                    if table.find(alreadyFoundItems, itemName) then continue end
                    
                    table.insert(alreadyFoundItems, itemName)
                end

                local section = GameItemsTab:Section({Name = "Items", Side = "Left"})

                for _, itemName in ipairs(alreadyFoundItems) do
                    section:Button({
                        Name = itemName,
                        Callback = function()
                        end
                    })
                end
            end
        end
    --end

    -- AIM TAB -

    AimSectionLeft:Toggle({
        Name = "Aim View",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AimViewBool,
        flag = "aimviewingflag",
        Callback = function(toggleBool)
            CG_AIM_VIEW_LIB.EnableAndDisableAimView()
        end,
    })

    AimSectionLeft:Toggle({
        Name = "Aim Lock",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AimLockBool,
        flag = "aimlockflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AimLockBool = toggleBool
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AimLockBool do

                    if shared.CG_DA_HOOD_CONFIG_TABLE.IsAttemptingToLock then
                        currentAimLockTarget = currentAimLockTarget ~= nil and shared.CG_DA_HOOD_CONFIG_TABLE.stickyAimLockBool and currentAimLockTarget or getPlayerClosestToFOV_RADIUS(shared.CG_DA_HOOD_CONFIG_TABLE.AimLockKnockedCheckBool)

                        if currentAimLockTarget then

                            local targetPredictedPosition = DA_HOOD_PREDICTION(currentAimLockTarget, shared.CG_DA_HOOD_CONFIG_TABLE.aimlockTargetPart)

                            if typeof(targetPredictedPosition) == "Vector3" then
                                if shared.CG_DA_HOOD_CONFIG_TABLE.aimsmoothness > 1 then
                                    Services.TweenService:Create(Camera, TweenInfo.new(shared.CG_DA_HOOD_CONFIG_TABLE.aimsmoothness / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                        CFrame = CFrame.new(Camera.CFrame.Position, targetPredictedPosition)
                                    }):Play()
                                else
                                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPredictedPosition)
                                end
                            end
                        end
                    end

                    task.wait()
                end
            end)
        end,
    })

    AimSectionLeft:Toggle({
        Name = "Anti Lock V1",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool,
        flag = "antiLockv1toggleflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool = toggleBool
    
            resetHipheight()
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool do
                    antiLock_VERSION_1()
                    task.wait()
                end

                if Vars.Character then
                    local humanoidRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end,
    })

    AimSectionLeft:Toggle({
        Name = "Anti Lock V2",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool,
        flag = "antiLockv2toggleflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool = toggleBool
    
            resetHipheight()
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockBool do
                    antiLock_VERSION_2()
                    task.wait()
                end

                if Vars.Character then
                    local humanoidRootPart = Vars.Character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end,
    })
    
    AimSectionLeft:Toggle({
        Name = "Resolver",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockResolveBool,
        flag = "antiLockResolverFlag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AntiLockResolveBool = toggleBool
        end,
    })

    local AimSectionRight = AimTab:Section({Name = "Extra", Side = "Right"})

    local PredictionAmountSlider = nil

    AimSectionRight:Dropdown({
        Name = "Prediction Mode",
        Options = {"Auto", "Manual"},
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_mode,
        flag = "aimpredictionmodeflag",
        Callback = function(Option)
            shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_mode = Option

            if Option == "Manual" then
                PredictionAmountSlider = AimSectionRight:Slider({
                    Name = "Prediction Amount",
                    Minimum = 1,
                    Maximum = 100,
                    Default = shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_amount,
                    flag = "aimpredictionamountflag",
                    Callback = function(Value)
                        shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_amount = Value
                    end,
                })
            else
                if PredictionAmountSlider ~= nil then
                    PredictionAmountSlider:RemoveSlider()
                    PredictionAmountSlider = nil
                end
            end
        end,
    })

    AimSectionRight:Dropdown({
        Name = "Prediction Type",
        Options = {"Velocity", "Movement"},
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_type,
        flag = "aimpredictiontypeflag",
        Callback = function(Option)
            shared.CG_DA_HOOD_CONFIG_TABLE.aim_prediction_type = Option
        end,
    })

    AimSectionRight:Dropdown({
        Name = "Aim Part",
        Options = targetParts,
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.defaultTargetPart,
        flag = "aimlockTargetPart",
        Callback = function(Option)
            shared.CG_DA_HOOD_CONFIG_TABLE.aimlockTargetPart = Option
        end,
    })

    AimSectionRight:Keybind({
        Name = "Aimlock Keybind",
        KeybindName = "Aimlock Keybind",
        Default = Enum.KeyCode.C,
        Mode = "Toggle",
        flag = "aimlockKeybind",
        Callback = function(Keybind, active)
            shared.CG_DA_HOOD_CONFIG_TABLE.IsAttemptingToLock = not shared.CG_DA_HOOD_CONFIG_TABLE.IsAttemptingToLock

            if not shared.CG_DA_HOOD_CONFIG_TABLE.IsAttemptingToLock then
                currentAimLockTarget = nil
            end

            NotiLib.new("info", "Da Hood", "Aimlock Enabled: " .. tostring(shared.CG_DA_HOOD_CONFIG_TABLE.IsAttemptingToLock))
        end,
    })

    AimSectionRight:Slider({
        Name = "Aim Smoothness",
        Minimum = 1,
        Maximum = 100,
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.aimsmoothness,
        flag = "AimSmoothnessFlag",
        Callback = function(Value)
            shared.CG_DA_HOOD_CONFIG_TABLE.aimsmoothness = Value
        end,
    })

    AimSectionRight:Toggle({
        Name = "Sticky Aim",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.stickyAimLockBool,
        flag = "stickyaimlockflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.stickyAimLockBool = toggleBool

            currentAimLockTarget = nil
        end
    })

    AimSectionRight:Toggle({
        Name = "Knocked check",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AimLockKnockedCheckBool,
        flag = "aimlockknockedcheckflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AimLockKnockedCheckBool = toggleBool
        end
    })
    
    -- VISUALS TAB --

    VisualsSectionLeft:Toggle({
        Name = "Show FOV",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.show_fov_bool,
        flag = "showfovflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.show_fov_bool = toggleBool

            VisualfovCircle.Visible = toggleBool
        end,
    })

    VisualsSectionLeft:Toggle({
        Name = "Box",
        Default = false,
        flag = "espBoxes",
        Callback = function(toggleBool)
            CG_ESP_LIB.EnableAndDisableBoxes(toggleBool)
        end,
    })
    
    VisualsSectionLeft:Toggle({
        Name = "Nametag",
        Default = false,
        flag = "espNameTags",
        Callback = function(toggleBool)
            CG_ESP_LIB.EnableAndDisableNametags(toggleBool)
        end,
    })
    
    VisualsSectionLeft:Toggle({
        Name = "Tracers",
        Default = false,
        flag = "espTracers",
        Callback = function(toggleBool)
            CG_ESP_LIB.EnableAndDisableTracers(toggleBool)
        end,
    })

    VisualsSectionLeft:Toggle({
        Name = "Health Bar",
        Default = false,
        flag = "espHealthBar",
        Callback = function(toggleBool)
            CG_ESP_LIB.EnableAndDisableHealthBar(toggleBool)
        end,
    })

    VisualsSectionLeft:Toggle({
        Name = "Armor Bar",
        Default = false,
        flag = "espArmorBar",
        Callback = function(toggleBool)
            CG_ESP_LIB.EnableAndDisableArmorBar(toggleBool)
        end,
    })

    local VisualsSectionRight = VisualsTab:Section({Name = "Extra", Side = "Right"})
    VisualsSectionRight:Slider({
        Name = "FOV Radius",
        Minimum = 1,
        Maximum = 1000,
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.FOV_RADIUS,
        flag = "fovRadiusFlag",
        Callback = function(Value)
            shared.CG_DA_HOOD_CONFIG_TABLE.FOV_RADIUS = Value
        end,
    })

    if isRealDaHoodGame() then
        -- AUTO FARM TAB --
        local AutoFarmTab = window:Page({Name = "AutoFarm"})
        local AutoFarmSection = AutoFarmTab:Section({Name = "Main", Side = "Left"})
        table.insert( autoFarmToggles, AutoFarmSection:Toggle({
            Name = "Auto Pickup Money",
            Default = shared.CG_DA_HOOD_CONFIG_TABLE.AutoPickupMoneyBool,
            flag = "autoPickupMoney",
            Callback = function(toggleBool)
                shared.CG_DA_HOOD_CONFIG_TABLE.AutoPickupMoneyBool = toggleBool

                if not toggleBool then return end

                disableOtherToggles(autoFarmToggles, "Auto Pickup Money")

                task.spawn(function()
                    while shared.CG_DA_HOOD_CONFIG_TABLE.AutoPickupMoneyBool do
                        if CG_FLY_LIB.IsFlying() then task.wait(); continue; end;
                        local dropsFolder = getDropFolder();
                        if not dropsFolder then task.wait(); continue; end;

                        for _, OBJ in ipairs(dropsFolder:GetChildren()) do
                            if not shared.CG_DA_HOOD_CONFIG_TABLE.AutoPickupMoneyBool then break end
                            if not OBJ:IsA("BasePart") or OBJ.Name ~= "MoneyDrop" then continue end
                            if OBJ.Transparency == 1 then continue end
        
                            teleportFunc(OBJ.Position)
        
                            repeat
                                pcall(custom_fireclickdetector, OBJ)
                                task.wait(2.5)
                            until not OBJ or OBJ.parent ~= dropsFolder or not shared.CG_DA_HOOD_CONFIG_TABLE.AutoPickupMoneyBool
                        end
        
                        task.wait()
                    end
                end)
            end,
        }) )

        table.insert( autoFarmToggles, AutoFarmSection:Toggle({
            Name = "Auto Stomp",
            Default = shared.CG_DA_HOOD_CONFIG_TABLE.AutoStompBool,
            flag = "autostomptoggleflag",
            Callback = function(toggleBool)
                shared.CG_DA_HOOD_CONFIG_TABLE.AutoStompBool = toggleBool

                if not toggleBool then return end

                disableOtherToggles(autoFarmToggles, "Auto Stomp")

                task.spawn(function()
                    while shared.CG_DA_HOOD_CONFIG_TABLE.AutoStompBool do
                        if CG_FLY_LIB.IsFlying() then task.wait(); continue; end;
                        if not Vars.Character then task.wait(); continue; end;
                        --
                        for _, Player in ipairs(Services.Players:GetPlayers()) do
                            local playerCharacter = Player.Character
                            if not playerCharacter then continue end
                            if not shared.CG_DA_HOOD_CONFIG_TABLE.AutoStompBool then break end
                            if not isKnocked(Player) or isDead(Player) then continue end

                            local oldLocalPosition = Vars.Character.PrimaryPart.Position

                            repeat
                                local playerPosition = playerCharacter.UpperTorso.Position
                                teleportFunc(playerPosition)

                                MainEvent:FireServer("Stomp")

                                task.wait(.1)
                            until isDead(Player) or not isKnocked(Player) or not shared.CG_DA_HOOD_CONFIG_TABLE.AutoStompBool

                            teleportFunc(oldLocalPosition)

                            task.wait(.2)
                        end
                        --
                        task.wait()
                    end
                end)
            end,
        }) )

        table.insert( autoFarmToggles, AutoFarmSection:Toggle({
            Name = "Auto Lettuce",
            Default = shared.CG_DA_HOOD_CONFIG_TABLE.AutoLettuceBool,
            flag = "autolettucefarmflag",
            Callback = function(toggleBool)
                shared.CG_DA_HOOD_CONFIG_TABLE.AutoLettuceBool = toggleBool

                if not toggleBool then return end

                disableOtherToggles(autoFarmToggles, "Auto Lettuce")

                task.spawn(function()
                    while shared.CG_DA_HOOD_CONFIG_TABLE.AutoLettuceBool do
                        if CG_FLY_LIB.IsFlying() then task.wait(); continue; end;
                        if not Vars.Character then task.wait(); continue; end;

                        local lettuceTool = getTool("[Lettuce]")
                        
                        local shopFolder = getShopFolder()
                        if not shopFolder then task.wait(); continue; end;
                        
                        local lettuceBuyPart = shopFolder:FindFirstChild("[Lettuce] - $5")
                        if not lettuceBuyPart then task.wait(); continue; end;

                        teleportFunc(autoLettuceFarmTeleportPosition)

                        if not lettuceTool then
                            fireclickdetector(lettuceBuyPart.ClickDetector, 15)

                            task.wait(.15)
                            continue
                        end

                        pcall(function()
                            lettuceTool.Parent = Vars.Character
                        end)

                        pcall(lettuceTool.Activate, lettuceTool)

                        task.wait()
                    end
                end)
            end,
        }) )
    end

    -- SETTINGS TAB --
    local SettingsTab = window:Page({Name = "Settings"})
    local SettingsSection = SettingsTab:Section({Name = "Main", Side = "Left"})

    SettingsSection:Keybind({
        Name = "Menu Keybind",
        KeybindName = "Menu Keybind",
        Default = Enum.KeyCode.V,
        Mode = "Toggle",
        flag = "menukeybindflag",
        Callback = function(Keybind, active)
        end,
    })

    -- MISC TAB --
    MiscSection:Toggle({
        Name = "Low GFX",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.low_gfx_toggle,
        flag = "lowgfxtoggleflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.low_gfx_toggle = toggleBool

            CG_LOW_GFX_LIB.setLowGfx(toggleBool)
        end
    })

    MiscSection:Toggle({
        Name = "Staff Checker",
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.da_hood_staff_checker,
        flag = "staffcheckerflag",
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.da_hood_staff_checker = toggleBool

            if not toggleBool then return end

            for _, Player in ipairs(Services.Players:GetPlayers()) do
                if Player == Vars.Player then continue end

                local isStaff = IsPlayerStaff(Player)

                if isStaff then
                    NotiLib.new("info", "Da Hood", Player.Name .. " IS A STAFF MEMBER !!!!")
                end
            end
        end
    })

    MiscSection:Toggle({
        Name = "Chat Spy",
        Default = false,
        flag = "chatspytoggleflag",
        Callback = function(active)
            shared.CG_DA_HOOD_CONFIG_TABLE.CHAT_SPY_BOOL = active

            if not active then return end

            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.CHAT_SPY_BOOL do
                    pcall(function()
                        Vars.Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
                        Vars.Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Position = UDim2.new(0, 0, .82, 0)
                    end)

                    task.wait()
                end
               
                pcall(function()
                    Vars.Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = false
                    Vars.Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Position = UDim2.new(0, 0, 0, 0)
                end)
            end)
        end
    })

    MiscSection:Button({
        Name = "Grenade Nuke",
        Callback = function()
            if CG_FLY_LIB.IsFlying() then return end
            if not Vars.Character then return end
            if shared.CG_DA_HOOD_GRENADE_NUKING then return end

            shared.CG_DA_HOOD_GRENADE_NUKING = true

            local totalGrenades = 0
                        
            local shopFolder = getShopFolder()
            if not shopFolder then
                shared.CG_DA_HOOD_GRENADE_NUKING = false
                return
            end
            
            local grenadeBuyPart = shopFolder:FindFirstChild("[Grenade] - $743")
            if not grenadeBuyPart then
                shared.CG_DA_HOOD_GRENADE_NUKING = false
                return
            end

            if getPlayerCash(Vars.Player) < 743 then
                shared.CG_DA_HOOD_GRENADE_NUKING = false
                return
            end

            local originalPosition = Vars.Character.PrimaryPart.Position

            repeat
                totalGrenades = 0
                for _, V in ipairs(Vars.Player.Backpack:GetChildren()) do
                    if V.Name == "[Grenade]" then
                        totalGrenades = totalGrenades + 1
                    end
                end

                if getPlayerCash(Vars.Player) < 743 then
                    break
                end

                teleportFunc(grenadeBuyPart.Head.Position)

                task.spawn(function()
                    pcall(fireclickdetector, grenadeBuyPart.ClickDetector, 15)
                end)

                task.wait(.1)
            until not Vars.Character or totalGrenades >= 11

            if Vars.Character ~= nil then
                teleportFunc(originalPosition)
                for _, V in ipairs(Vars.Player.Backpack:GetChildren()) do
                    if V.Name == "[Grenade]" then
                        V.Parent = Vars.Character
                        V:Activate()
                        V.Parent = Vars.Player.Backpack
                        task.wait()
                        V.Parent = Vars.Character
                        V:Activate()
                        task.wait()
                    end
                end
            end

            shared.CG_DA_HOOD_GRENADE_NUKING = false
        end
    })

    MiscSection:Button({
        Name = "Redeem codes",
        Callback = function()
            local daHoodCodes = nil
            NotiLib.new("info", "Da Hood", "Fetching Latest Da Hood Codes!")
            
            local dh_codes_fetched = pcall(function()
                daHoodCodes = Services.HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/da%20hood%20codes.json", false))
            end)

            if not dh_codes_fetched then
                return NotiLib.new("error", "Da Hood", "Failed To Fetch Latest Da Hood Codes!")
            end

            NotiLib.new("success", "Da Hood", "Fetched Latest Da Hood Codes!")

            for _, dh_promo_code in ipairs(daHoodCodes) do
                for index = 1, 100 do
                    MainEvent:FireServer("EnterPromoCode", dh_promo_code)
                end
                task.wait(11)
            end
        end
    })

    MiscSection:Button({
        Name = "Target Player GUI",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/CG_DA_HOOD_TARGET_GUI.lua", false))()

            if shared.CG_DA_HOOD_TARGET_GUI_FUNCTIONS then
                shared.CG_DA_HOOD_TARGET_GUI_FUNCTIONS.setInternelFunctions({
                    getPlayerCash = getPlayerCash,
                    TeleportFunc = teleportFunc,
                    IsKnocked = isKnocked,
                    IsDead = isDead,
                    getTool = getTool
                })
            end
        end

    })

    MiscSection:Button({
        Name = "Rejoin Server",
        Callback = function()
            return Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Vars.Player)
        end
    })

    local MiscSectionRight = MiscTab:Section({Name = "Money Dropper", Side = "Right"})
    MiscSectionRight:Slider({
        Name = "Drop Amount",
        Minimum = 100,
        Maximum = 10050,
        Default = shared.CG_DA_HOOD_CONFIG_TABLE.AUTO_DROP_CASH_AMOUNT,
        flag = "moneydropamountflag",
        Callback = function(Value)
            shared.CG_DA_HOOD_CONFIG_TABLE.AUTO_DROP_CASH_AMOUNT = Value
        end,
    })

    MiscSectionRight:Toggle({
        Name = "Auto Drop Cash",
        Default = false,
        Callback = function(toggleBool)
            shared.CG_DA_HOOD_CONFIG_TABLE.AUTO_DROP_CASH_BOOL = toggleBool

            if not toggleBool then return end

            task.spawn(function()
                while shared.CG_DA_HOOD_CONFIG_TABLE.AUTO_DROP_CASH_BOOL do
                    MainEvent:FireServer("DropMoney", tostring( math.clamp( shared.CG_DA_HOOD_CONFIG_TABLE.AUTO_DROP_CASH_AMOUNT, 0, 10000) ))
                    task.wait()
                end
            end)
        end
    })

    if type(window.Initialize) == "function" then
        window:Initialize()
    end

    NotiLib.new("success", "Da Hood", "CG's Da Hood Script Loaded!")
    NotiLib.new("info", "Da Hood", "Open and close key is Insert")
end)