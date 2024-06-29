local lowGfxModule = {}

local Lighting = game:GetService("Lighting")

shared.CG_LOW_GFX_CONNECTIONS = shared.CG_LOW_GFX_CONNECTIONS or {}

for _, Connection in pairs(shared.CG_LOW_GFX_CONNECTIONS) do
    pcall(Connection.Disconnect, Connection)
end

table.clear(shared.CG_LOW_GFX_CONNECTIONS)

local function getProperty(obj, propName)
    local success, value = pcall(function()
        return obj[propName]
    end)

    return success and value or nil
end

local function setProperty(obj, propName, value)
    return pcall(function()
        obj[propName] = value
    end)
end


shared.CG_LOW_GFX_LIGHTING_CACHE = shared.CG_LOW_GFX_LIGHTING_CACHE or {
    GlobalShadows = { Original = getProperty(Lighting, "GlobalShadows"), SwappedVersion = false },
    ShadowSoftness = { Original = getProperty(Lighting, "ShadowSoftness"), SwappedVersion = 0 },
    Technology = { Original = getProperty(Lighting, "Technology"), SwappedVersion = Enum.Technology.Voxel },
    FogEnd = { Original = getProperty(Lighting, "FogEnd"), SwappedVersion = 9e9 },
    FogStart = { Original = getProperty(Lighting, "FogStart"), SwappedVersion = 9e9 },
}

shared.CG_LOW_GFX_PART_CACHE = shared.CG_LOW_GFX_PART_CACHE or {}

local function addToPartCache(Part)
    if typeof(Part) ~= "Instance" or not Part:IsA("BasePart") then return end
    if shared.CG_LOW_GFX_PART_CACHE[Part] ~= nil then return end

    shared.CG_LOW_GFX_PART_CACHE[Part] = {
        Material = getProperty(Part, "Material"),
        Reflectance = getProperty(Part, "Reflectance"),
        CastShadow = getProperty(Part, "CastShadow")
    }
end

for _, Part in pairs(workspace:GetDescendants()) do
    if not Part:IsA("BasePart") then continue end

    addToPartCache(Part)
end

table.insert(shared.CG_LOW_GFX_CONNECTIONS, workspace.DescendantAdded:Connect(function(Part)
    if not Part:IsA("BasePart") then return end

    addToPartCache(Part)
end))

table.insert(shared.CG_LOW_GFX_CONNECTIONS, workspace.DescendantRemoving:Connect(function(Part)
    if not Part:IsA("BasePart") then return end

    pcall(function()
        shared.CG_LOW_GFX_PART_CACHE[Part] = nil
    end)
end))

function lowGfxModule.setLowGfx(lowGfxBool)
    for Part, Properties in pairs(shared.CG_LOW_GFX_PART_CACHE) do
        setProperty(Part, "Material", lowGfxBool and Enum.Material.SmoothPlastic or Properties.Material)
        setProperty(Part, "Reflectance", lowGfxBool and 0 or Properties.Reflectance)
        setProperty(Part, "CastShadow", lowGfxBool and false or Properties.CastShadow)
    end

    for Property, Data in pairs(shared.CG_LOW_GFX_LIGHTING_CACHE) do
        setProperty(Lighting, Property, lowGfxBool and Data.SwappedVersion or Data.Original)
    end
end

lowGfxModule.setLowGfx(false)

return lowGfxModule