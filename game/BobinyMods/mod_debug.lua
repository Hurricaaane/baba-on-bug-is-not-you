
local MOD = {}

function MOD.load(loader)
    local debug = require(loader.path .. "debug/debug")
    debug.setBobiny(loader.bobiny)
    debug.createHookEnableDebugMode()
end

return MOD