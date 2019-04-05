
local MOD = {
    identifier = "print-all",
    customData = {
        author = "Ha3"
    }
}

function MOD.load(loader)
    local mod = require(loader.path .. "print-all/print-all")
    mod.dependencies(function(dependencies)
        dependencies.bobiny = loader.bobiny
    end)
    --mod.start()
end

return MOD