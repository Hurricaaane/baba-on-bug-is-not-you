local M = {}

local bobinyPrefix = (__BOBINY_T or "")

local _deps = {
    findFiles = function()
        return MF_filelist("BobinyMods/", "*.lua")
    end,
    requireMod = function(path)
        return require(path)
    end
}

function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

function M.findAllModDescriptors()
    local prefix = "mod_"
    local modFiles = _deps.findFiles()

    local modDescriptors = {}
    for _,modFile in pairs(modFiles) do
        local fileIsAMod = modFile:sub(1, #prefix) == prefix
        if (fileIsAMod) then
            local modScript = modFile:sub(1, -5)
            local data = _deps.requireMod(bobinyPrefix .. "BobinyMods/" .. modScript)
            local descriptor = {
                name = modScript,
                data = data
            }
            table.insert(modDescriptors, descriptor)
        end
    end

    return modDescriptors
end

function M.loadMods(bobiny)
    local loader = {
        bobiny = bobiny,
        path = bobinyPrefix .. "BobinyMods/"
    }
    local modDescriptors = M.findAllModDescriptors()
    for _,modDescriptor in ipairs(modDescriptors) do
        modDescriptor.data.load(loader)
    end
    return modDescriptors
end

return M