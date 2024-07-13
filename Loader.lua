local tweenService = game:GetService("TweenService")
shared.CG_HUB_LOADING = shared.CG_HUB_LOADING or false
shared.CG_HUB_DEPENDENCIES = shared.CG_HUB_DEPENDENCIES or {}

if shared.CG_HUB_LOADING then return end

shared.CG_HUB_LOADING = true

if shared.loader_load_screen ~= nil then
    shared.loader_load_screen:Destroy()
    shared.loader_load_screen = nil
end

shared.loader_load_screen = game:GetObjects("rbxassetid://18261449357")[1]
shared.loader_load_screen.Parent = game:GetService("CoreGui")

local container = shared.loader_load_screen.Container

local tween1 = tweenService:Create(container, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    Size = UDim2.new(0, 100, 0, 100)
})

local tween2 = tweenService:Create(container.Logo, TweenInfo.new(.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    Size = UDim2.new(.5, 0, .5, 0)
})

tween1:Play()
tween2:Play()
tween2.Completed:Wait()

task.wait(.25)

local tween3 = tweenService:Create(container.Logo, TweenInfo.new(.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    Size = UDim2.new(0, 0, 0, 0)
})

tween3:Play()
tween3.Completed:Wait()

local tween4 = tweenService:Create(container, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    Size = UDim2.new(0, 300, 0, 150)
})

local tween5 = tweenService:Create(container.UICorner, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    CornerRadius = UDim.new(0, 6)
})


tween4:Play()
tween5:Play()
tween5.Completed:Wait()

container.Logo:Destroy()

container.Elements.Visible = true

local tween6 = tweenService:Create(container.Elements, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
    Size = UDim2.new(.945, 0, .9, 0)
})

tween6:Play()

local games = {
    [5602055394] = "DaHood", -- [[ Hood Modded ]]
    [18128019573] = "DaHood", -- [[ Da Fights ]]
    [17809101348] = "DaHood", -- [[ New Hood ]]
    [2788229376] = "DaHood", -- [[ Da Hood Original ]]
    [16033173781] = "DaHood", -- [[ Da Hood Macro ]]
    [7213786345] = "DaHood", -- [[ Da Hood Voice Chat ]]
    [17897702920] = "DaHood", -- [[ OG Da Hood ]]
    [9825515356] = "DaHood", -- [[ Hood Customs ]]
    [18111448661] = "DaHood", -- [[ Da Uphill ]]
    [17326592548] = "DaHood", -- [[ Dah Hood ]]
    [17403265390] = "DaHood", -- [[ Da Downhill ]]
    [14566134687] = "DaHood", -- [[ Da-Customs ]]
    [18111451594] = "DaHood", -- [[ Da Bank ]]
    [16435867341] = "DaHood", -- [[ Mad Hood ]]
    --[17714122625] = "DaHood", -- [[ DaH Hood ]]
    --[2753915549] = "Bloxfruits",
}

if not games[game.PlaceId] then
    games[game.PlaceId] = "UniversalScript"
end

local Dependencies = {
    CG_AIM_VIEW_LIB = "DH_AIM_VIEWER",
    CG_ESP_LIB = "CG_ESP_2024",
    CG_FLY_LIB = "CG_FLY_SCRIPT",
    CG_LOW_GFX_LIB = "CG_LOW_GFX_MODULE",
}

local Data = {
    GithubRepOwner = "botdevXD",
    GithubRepName = "CGHub",
    GamesFolder = "https://raw.githubusercontent.com/%s/%s/main/Games/%s",
    DepsFolder = "https://raw.githubusercontent.com/%s/%s/main/Dependencies/%s",
}

local currentPlaceId = game.PlaceId

local function safeLoadString(source)
    local success, returnVal = pcall(loadstring, source)
    return success and returnVal
end

local function safeLoad(callBack)
    if type(callBack) ~= "function" then return end

    local success, returnVal = pcall(callBack)
    return success and returnVal
end

local function getScriptSource(gameId)
    local fetchedSource, returnSource = pcall(function()
        local gameSourceUrl = Data.GamesFolder:format(Data.GithubRepOwner, Data.GithubRepName, games[gameId] .. ".lua")

        return game:HttpGet(gameSourceUrl, true)
    end)

    return fetchedSource and returnSource
end

local function getDependencySource(depName)
    local fetchedSource, returnSource = pcall(function()
        local depUrl = Data.DepsFolder:format(Data.GithubRepOwner, Data.GithubRepName, depName .. ".lua")

        return game:HttpGet(depUrl, true)
    end)

    return fetchedSource and returnSource
end

for DependencyIndex, DependencyName in pairs(Dependencies) do
    if shared.CG_HUB_DEPENDENCIES[DependencyIndex] ~= nil then continue end

    local dependencySource = getDependencySource(DependencyName)
    local loadedDependency = safeLoadString(dependencySource)

    if loadedDependency then
        local dependencyData = safeLoad(loadedDependency)
        if not dependencyData then
            warn("Failed to load dependency: " .. DependencyName)
            break
        end

        shared.CG_HUB_DEPENDENCIES[DependencyIndex] = dependencyData
        continue
    end

    warn("Failed to load dependency: " .. DependencyName)
end

container.Elements.LoadButton.MouseButton1Click:Connect(function()
    local currentGameSource = getScriptSource(currentPlaceId)
    if not currentGameSource then
        return warn("Failed to fetch game source")
    end
    
    local loadedGameScript = safeLoadString(currentGameSource)
    if not loadedGameScript then
        return warn("Failed to load game script")
    end

    shared.loader_load_screen:Destroy()
    shared.loader_load_screen = nil

    safeLoad(loadedGameScript)
end)
shared.CG_HUB_LOADING = false

--[[
----------------------------
------- GAMES TO ADD -------
----------------------------

-- Grand Piece Online
-- Bloxfruits
-- Jailbreak
-- Phantom Forces
-- Bee Swarm Simulator
]]