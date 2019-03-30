
local MOD = {}

function MOD.load(loader)
    local sideways = require(loader.path .. "sideways/sideways-example")
    sideways.setBobiny(loader.bobiny)
    sideways.createHookSidewaysControls()
end

return MOD