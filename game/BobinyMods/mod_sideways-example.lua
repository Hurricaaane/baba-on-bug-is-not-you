
local MOD = {}

function MOD.load(path)
    local sideways = require(path .. "sideways/sideways-example")
    sideways.createHookSidewaysControls()
end

return MOD