
local MOD = {}

function MOD.load(loader)
    local mod = require(loader.path .. "sideways/sideways-example")
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    mod.createHookSidewaysControls()
end

return MOD