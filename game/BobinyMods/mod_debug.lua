
local MOD = {}

function MOD.load(path)
    local debug = require(path .. "debug/debug")
    debug.createHookEnableDebugMode()
end

return MOD