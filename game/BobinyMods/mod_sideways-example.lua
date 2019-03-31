
local MOD = {
    identifier = "sideways",
    customData = {
        author = "Ha3"
    }
}

function MOD.load(loader)
    local mod = require(loader.path .. "sideways/sideways-example")
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    mod.start()
end

return MOD