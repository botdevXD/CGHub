local noclipModule = {}

local runService = game:GetService("RunService")

shared.CG_NOCLIP_CONNECTIONS = shared.CG_NOCLIP_CONNECTIONS or {}
shared.CG_NOCLIP_MODULE_PART_CACHE = shared.CG_NOCLIP_MODULE_PART_CACHE or {}

shared.CG_noClipEnabled = false

for _, connection in ipairs(shared.CG_NOCLIP_CONNECTIONS) do
    pcall(connection.Disconnect, connection)
end

table.clear(shared.CG_NOCLIP_CONNECTIONS)

local function addPartToCache(part)
    if typeof(part) ~= "Instance" or not part:IsA("BasePart") then return end
    if shared.CG_NOCLIP_MODULE_PART_CACHE[part] ~= nil then return end
    if part.CanCollide == false then return end

    shared.CG_NOCLIP_MODULE_PART_CACHE[part] = {
        CanCollide = part.CanCollide
    }
end

for _, part in ipairs(workspace:GetDescendants()) do
    if not part:IsA("BasePart") then continue end

    addPartToCache(part)
end

table.insert(shared.CG_NOCLIP_CONNECTIONS, workspace.DescendantAdded:Connect(function(addedObject)
    if not addedObject:IsA("BasePart") then return end

    addPartToCache(addedObject)

    if shared.CG_noClipEnabled then
        addedObject.CanCollide = false
    end
end))

table.insert(shared.CG_NOCLIP_CONNECTIONS, workspace.DescendantRemoving:Connect(function(removedObject)
    if not removedObject:IsA("BasePart") then return end

    shared.CG_NOCLIP_MODULE_PART_CACHE[removedObject] = nil
end))

function noclipModule.setNoClipEnabled(value)
    shared.CG_noClipEnabled = value

    for part, data in pairs(shared.CG_NOCLIP_MODULE_PART_CACHE) do
        if value then
            part.CanCollide = false
            
            continue
        end

        part.CanCollide = data.CanCollide
    end
end

function noclipModule.IsNoclipEnabled()
    return shared.CG_noClipEnabled
end

return noclipModule