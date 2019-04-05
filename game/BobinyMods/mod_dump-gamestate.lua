
local MOD = {
    identifier = "dump-gamestate",
    customData = {
        author = "Ha3"
    }
}

function MOD.load(loader)
    local mod = require(loader.path .. MOD.identifier .. "/" .. MOD.identifier)
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    mod.start()
end

return MOD