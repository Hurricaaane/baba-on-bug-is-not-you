local M = {}

local bobinyPrefix = (__BOBINY_T or "")

function M._findFiles()
    return MF_filelist("BobinyMods/", "*.lua")
end

function M._requireMod(path)
    return require(path)
end

function M.findAllModDescriptors()
    local prefix = "mod_"
    local modFiles = M._findFiles()

    local modDescriptors = {}
    for _,modFile in pairs(modFiles) do
        local fileIsAMod = modFile:sub(1, #prefix) == prefix
        if (fileIsAMod) then
            local modScript = modFile:sub(1, -5)
            local data = M._requireMod(bobinyPrefix .. "BobinyMods/" .. modScript)
            local descriptor = {
                name = modScript,
                data = data
            }
            table.insert(modDescriptors, descriptor)
        end
    end

    return modDescriptors
end

function M.loadMods()
    local modDescriptors = M.findAllModDescriptors()
    for _,modDescriptor in ipairs(modDescriptors) do
        modDescriptor.data.load(bobinyPrefix .. "BobinyMods/")
    end
    return modDescriptors
end

return M