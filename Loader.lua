local games = {
    [2788229376] = "DaHood",
    [16033173781] = "DaHood",
    [7213786345] = "DaHood"
}

local Dependencies = {
    CG_AIM_VIEW_LIB = "DH_AIM_VIEWER",
    CG_ESP_LIB = "CG_ESP_2024",
    CG_FLY_LIB = "CG_FLY_SCRIPT",
    CG_LOW_GFX_LIB = "CG_LOW_GFX_MODULE",
}

local Data = {
    GithubRepOwner = "botdevXD",
    GithubRepName = "CGHub",
    GamesFolder = "https://raw.githubusercontent.com/%s/%s/main/Games/",
    DepsFolder = "https://raw.githubusercontent.com/%s/%s/main/Dependencies/",
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
        local gamesFolderUrl = Data.GamesFolder:format(Data.GithubRepOwner, Data.GithubRepName)
        local gameSourceUrl = gamesFolderUrl .. games[gameId] .. ".lua"

        return game:HttpGet(gameSourceUrl, true)
    end)

    return fetchedSource and returnSource
end

local function getDependencySource(depName)
    local fetchedSource, returnSource = pcall(function()
        local depsFolderUrl = Data.DepsFolder:format(Data.GithubRepOwner, Data.GithubRepName)
        local depSourceUrl = depsFolderUrl .. depName .. ".lua"

        return game:HttpGet(depSourceUrl, true)
    end)

    return fetchedSource and returnSource
end

for DependencyIndex, DependencyName in pairs(Dependencies) do
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

local currentGameSource = getScriptSource(currentPlaceId)
if not currentGameSource then
    return warn("Failed to fetch game source")
end

local loadedGameScript = safeLoadString(currentGameSource)
if not loadedGameScript then
    return warn("Failed to load game script")
end

print("Debug 1")
safeLoad(loadedGameScript)
print("Debug 2")

--[[
----------------------------
------- GAMES TO ADD -------
----------------------------

-- Grand Piece Online
-- Bloxfruits
-- Jailbreak
-- Phantom Forces
]]