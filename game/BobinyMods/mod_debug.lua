
local MOD = {}

function MOD.load(loader)
    local mod = require(loader.path .. "debug/debug")
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    mod.start()
end

return MOD