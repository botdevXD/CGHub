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
    
    local release_Dev_Features = false
    
    local AimTab = window:Page({Name = "Aim"})
    local VisualsTab = window:Page({Name = "Visuals"})

    local AimSectionLeft = AimTab:Section({Name = "Main", Side = "Left"})
    local VisualsSectionLeft = VisualsTab:Section({Name = "Main", Side = "Left"})
end)