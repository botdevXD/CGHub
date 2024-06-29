local games = {
    [2788229376] = "DaHood",
    [16033173781] = "DaHood",
    [7213786345] = "DaHood"
}

local Dependencies = {

}

local Data = {
    GithubRepOwner = "botdevXD",
    GithubRepName = "CGHub",
    GamesFolder = "https://raw.githubusercontent.com/%s/%s/main/Games/",
    DepsFolder = "https://raw.githubusercontent.com/%s/%s/main/Games/",
}

local currentPlaceId = game.PlaceId

local function getScriptSource(gameId)
    local fetchedSource, returnSource pcall(function()
        local gamesFolderUrl = Data.GamesFolder:format(Data.GithubRepOwner, Data.GithubRepName)
        local gameSourceUrl = gamesFolderUrl .. games[gameId] .. ".lua"

        return game:HttpGet(gameSourceUrl, true)
    end)

    return fetchedSource and returnSource
end

if games[currentPlaceId] == nil then
    return
end