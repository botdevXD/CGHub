local Players = game:GetService("Players")
task.spawn(function()
    repeat
        task.wait()
    until game:IsLoaded()

    local ClonedPlaceId = game.PlaceId
    local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/botdevXD/GRUBHUB_TECH/main/NOTI_LIB.lua", true))()
    
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

    CG_FLY_LIB.EnableAndDisableFly(false)

    shared.CG_UNIVERSAL_CONNECTIONS = shared.CG_UNIVERSAL_CONNECTIONS or {}

    for _, signalConnection in ipairs(shared.CG_UNIVERSAL_CONNECTIONS) do
        pcall(signalConnection.Disconnect, signalConnection)
    end
    
    table.clear(shared.CG_UNIVERSAL_CONNECTIONS)

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

    local window = Library:New({
        Name = "CG's Universal Script",
        Theme = "Dark",
        Accent = Color3.fromRGB(50, 100, 255),
        Bind = Enum.KeyCode.V
    })

    shared.CG_CURRENT_WINDOW = window
    
    local Services = {
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        Players = game:GetService("Players"),
        TweenService = game:GetService("TweenService")
    }

    local Vars = {
        Player = Services.Players.LocalPlayer,
    }

    Vars.Character = Vars.Player.Character or Vars.Player.CharacterAdded:Wait()
    
    local AimTab = window:Page({Name = "Aim"})
    local VisualsTab = window:Page({Name = "Visuals"})

    local AimSectionLeft = AimTab:Section({Name = "Main", Side = "Left"})
    local VisualsSectionLeft = VisualsTab:Section({Name = "Main", Side = "Left"})

    local targetParts = {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "HumanoidRootPart"
    }

    local currentAimLockTarget = nil
    shared.CG_UNIVERSAL_CONFIG_TABLE = {
        FOV_RADIUS = 75,
        show_fov_bool = false,

        -- AIMBOT CONFIG --
        AimLockBool = false,
        aimsmoothness = 1,
        defaultTargetPart = targetParts[1],
        aimlockTargetPart = targetParts[1],
        stickyAimLockBool = false,
        IsAttemptingToLock = false,
        aim_prediction_mode = "Manual",
        aim_prediction_type = "Velocity",
        aim_prediction_amount = 14,
        AntiLockResolveBool = false,
    }

    local VisualfovCircle = Drawing.new("Circle")
    VisualfovCircle.Thickness = 2
    VisualfovCircle.Transparency = 1
    VisualfovCircle.Visible = false
    VisualfovCircle.Color = Color3.fromRGB(255, 255, 255)
    VisualfovCircle.Filled = false
    VisualfovCircle.Radius = shared.CG_UNIVERSAL_CONFIG_TABLE.FOV_RADIUS
    shared.CG_FOV_CIRCLE_VISUAL = VisualfovCircle

    local function makeConnection(event, callback)
        local connection = event:Connect(callback)
    
        table.insert(shared.CG_UNIVERSAL_CONNECTIONS, connection)
    
        return connection
    end

    local function patchVelocity(targetPartVelocity)
        local patchedTargetVelocity = Vector3.new(
            math.clamp(targetPartVelocity.X, -10, 10),
            math.clamp(targetPartVelocity.Y, -15, 15),
            math.clamp(targetPartVelocity.Z, -10, 10)
        )

        return patchedTargetVelocity
    end


    local function getPlayerClosestToFOV_RADIUS()
        local closestPlayer = nil
        local closestDistance = shared.CG_UNIVERSAL_CONFIG_TABLE.FOV_RADIUS

        for _, Player in ipairs(Services.Players:GetPlayers()) do
            if Player == Vars.Player then continue end

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

    local function AIM_LOCK_PREDICTION(targetPlr, targetPart)
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

        if shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_mode == "Manual" then
            local targetPartVelocity = targetPlr.Character.PrimaryPart.AssemblyLinearVelocity

            if shared.CG_UNIVERSAL_CONFIG_TABLE.AntiLockResolveBool then
                targetPartVelocity = patchVelocity(targetPartVelocity)
            end

            local Distance = (Vars.Character.HumanoidRootPart.Position - targetPosition).Magnitude
            local Time = Distance / PlayerPing
            local PredictedPosition = targetPosition + targetPartVelocity * Time * ((shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_amount / 1000) * 20)

            return PredictedPosition
        end
    
        if shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_type == "Velocity" then
            local targetPartVelocity = targetPlr.Character.PrimaryPart.AssemblyLinearVelocity

            if shared.CG_UNIVERSAL_CONFIG_TABLE.AntiLockResolveBool then
                targetPartVelocity = patchVelocity(targetPartVelocity)
            end

            local TargetDistance = (Vars.Character.HumanoidRootPart.Position - targetPosition).Magnitude
        
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

    makeConnection(Vars.Player.CharacterAdded, function(Character)
        Vars.Character = Character
    end)

    makeConnection(Services.RunService.RenderStepped, function()
        if not VisualfovCircle then return end

        local mosuePosX, mosuePosY = Services.UserInputService:GetMouseLocation().X, Services.UserInputService:GetMouseLocation().Y
        VisualfovCircle.Radius = shared.CG_UNIVERSAL_CONFIG_TABLE.FOV_RADIUS
        VisualfovCircle.Position = Vector2.new(mosuePosX, mosuePosY)
    end)

    AimSectionLeft:Toggle({
        Name = "Aim Lock",
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.AimLockBool,
        flag = "aimlockflag",
        Callback = function(toggleBool)
            shared.CG_UNIVERSAL_CONFIG_TABLE.AimLockBool = toggleBool
    
            if not toggleBool then return end
    
            task.spawn(function()
                while shared.CG_UNIVERSAL_CONFIG_TABLE.AimLockBool do

                    pcall(function()
                        if shared.CG_UNIVERSAL_CONFIG_TABLE.IsAttemptingToLock then
                            currentAimLockTarget = currentAimLockTarget ~= nil and shared.CG_UNIVERSAL_CONFIG_TABLE.stickyAimLockBool and currentAimLockTarget or getPlayerClosestToFOV_RADIUS()
    
                            if currentAimLockTarget then
    
                                local targetPredictedPosition = AIM_LOCK_PREDICTION(currentAimLockTarget, shared.CG_UNIVERSAL_CONFIG_TABLE.aimlockTargetPart)
    
                                if typeof(targetPredictedPosition) == "Vector3" then
                                    if shared.CG_UNIVERSAL_CONFIG_TABLE.aimsmoothness > 1 then
                                        Services.TweenService:Create(Camera, TweenInfo.new(shared.CG_UNIVERSAL_CONFIG_TABLE.aimsmoothness / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                            CFrame = CFrame.new(Camera.CFrame.Position, targetPredictedPosition)
                                        }):Play()
                                    else
                                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPredictedPosition)
                                    end
                                end
                            end
                        end
                    end)

                    task.wait()
                end
            end)
        end,
    })

    local AimSectionRight = AimTab:Section({Name = "Extra", Side = "Right"})

    local PredictionAmountSlider = nil

    AimSectionRight:Dropdown({
        Name = "Prediction Mode",
        Options = {"Auto", "Manual"},
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_mode,
        flag = "aimpredictionmodeflag",
        Callback = function(Option)
            shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_mode = Option

            if Option == "Manual" then
                PredictionAmountSlider = AimSectionRight:Slider({
                    Name = "Prediction Amount",
                    Minimum = 1,
                    Maximum = 100,
                    Default = shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_amount,
                    flag = "aimpredictionamountflag",
                    Callback = function(Value)
                        shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_amount = Value
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
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_type,
        flag = "aimpredictiontypeflag",
        Callback = function(Option)
            shared.CG_UNIVERSAL_CONFIG_TABLE.aim_prediction_type = Option
        end,
    })

    AimSectionRight:Dropdown({
        Name = "Aim Part",
        Options = targetParts,
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.defaultTargetPart,
        flag = "aimlockTargetPart",
        Callback = function(Option)
            shared.CG_UNIVERSAL_CONFIG_TABLE.aimlockTargetPart = Option
        end,
    })

    AimSectionRight:Keybind({
        Name = "Aimlock Keybind",
        KeybindName = "Aimlock Keybind",
        Default = Enum.KeyCode.C,
        Mode = "Toggle",
        flag = "aimlockKeybind",
        Callback = function(Keybind, active)
            shared.CG_UNIVERSAL_CONFIG_TABLE.IsAttemptingToLock = not shared.CG_UNIVERSAL_CONFIG_TABLE.IsAttemptingToLock

            if not shared.CG_UNIVERSAL_CONFIG_TABLE.IsAttemptingToLock then
                currentAimLockTarget = nil
            end

            NotiLib.new("info", "Universal", "Aimlock Enabled: " .. tostring(shared.CG_UNIVERSAL_CONFIG_TABLE.IsAttemptingToLock))
        end,
    })

    AimSectionRight:Slider({
        Name = "Aim Smoothness",
        Minimum = 1,
        Maximum = 100,
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.aimsmoothness,
        flag = "AimSmoothnessFlag",
        Callback = function(Value)
            shared.CG_UNIVERSAL_CONFIG_TABLE.aimsmoothness = Value
        end,
    })

    AimSectionRight:Toggle({
        Name = "Sticky Aim",
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.stickyAimLockBool,
        flag = "stickyaimlockflag",
        Callback = function(toggleBool)
            shared.CG_UNIVERSAL_CONFIG_TABLE.stickyAimLockBool = toggleBool

            currentAimLockTarget = nil
        end
    })

    VisualsSectionLeft:Toggle({
        Name = "Show FOV",
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.show_fov_bool,
        flag = "showfovflag",
        Callback = function(toggleBool)
            shared.CG_UNIVERSAL_CONFIG_TABLE.show_fov_bool = toggleBool

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

    local VisualsSectionRight = VisualsTab:Section({Name = "Extra", Side = "Right"})
    VisualsSectionRight:Slider({
        Name = "FOV Radius",
        Minimum = 1,
        Maximum = 1000,
        Default = shared.CG_UNIVERSAL_CONFIG_TABLE.FOV_RADIUS,
        flag = "fovRadiusFlag",
        Callback = function(Value)
            shared.CG_UNIVERSAL_CONFIG_TABLE.FOV_RADIUS = Value
        end,
    })
end)