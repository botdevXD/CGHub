local tweenService = cloneref(game:GetService("TweenService"))
shared.CG_HUB_LOADING = shared.CG_HUB_LOADING or false
shared.CG_HUB_DEPENDENCIES = shared.CG_HUB_DEPENDENCIES or {}

if shared.CG_HUB_LOADING then return end

shared.CG_HUB_LOADING = true

if shared.loader_load_screen ~= nil then
    shared.loader_load_screen:Destroy()
    shared.loader_load_screen = nil
end

shared.loader_load_screen = game:GetObjects("rbxassetid://18261449357")[1]
shared.loader_load_screen.Parent = cloneref(game:GetService("CoreGui"))

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
    [5602055394] = "Da Hood", -- [[ Hood Modded ]]
    [18128019573] = "Da Hood", -- [[ Da Fights ]]
    [17809101348] = "Da Hood", -- [[ New Hood ]]
    [2788229376] = "Da Hood", -- [[ Da Hood Original ]]
    [16033173781] = "Da Hood", -- [[ Da Hood Macro ]]
    [7213786345] = "Da Hood", -- [[ Da Hood Voice Chat ]]
    [17897702920] = "Da Hood", -- [[ OG Da Hood ]]
    [9825515356] = "Da Hood", -- [[ Hood Customs ]]
    [18111448661] = "Da Hood", -- [[ Da Uphill ]]
    [17326592548] = "Da Hood", -- [[ Dah Hood ]]
    [17403265390] = "Da Hood", -- [[ Da Downhill ]]
    [14566134687] = "Da Hood", -- [[ Da-Customs ]]
    [18111451594] = "Da Hood", -- [[ Da Bank ]]
    [16435867341] = "Da Hood", -- [[ Mad Hood ]]
    [18710690149] = "Da Hood", -- [[ Del Hood Aim ]]
    [137233212971328] = "Da Hood", -- [[ Soul-Hood ]]
    [101578422316976] = "Da Hood",
    --[17714122625] = "Da Hood", -- [[ DaH Hood ]]
    --[2753915549] = "Bloxfruits",
}

if not games[game.PlaceId] then
    games[game.PlaceId] = "Universal"
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
        local gameSourceUrl = Data.GamesFolder:format(Data.GithubRepOwner, Data.GithubRepName, tostring(games[gameId]):gsub(" ", "") .. ".lua")

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

container.Elements.LoadButton.Text = "Loading Dependencies..."

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

container.Elements.LoadButton.Text = "Press to load " .. games[currentPlaceId] .. " Script"

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
