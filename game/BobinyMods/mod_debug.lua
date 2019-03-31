
local MOD = {
    identifier = "debug",
    customData = {
        author = "Ha3"
    }
}

function MOD.load(loader)
    local mod = require(loader.path .. "debug/debug")
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    mod.start()
end

function MOD.onAllModsLoaded(modDescriptors)
    for _, modDescriptor in ipairs(modDescriptors) do
        local identifier = modDescriptor.identifier
        local scriptName = modDescriptor.scriptName
        local data = modDescriptor.data
    end
end

return MOD