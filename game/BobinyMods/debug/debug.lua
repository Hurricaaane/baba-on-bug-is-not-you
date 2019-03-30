local M = {}

local bobiny
local hookHandle

function M.setBobiny(bobinyProvided)
    bobiny = bobinyProvided
end

function M.doEnableDebugMode(...)
    generaldata.strings[BUILD] = "debug"

    hookHandle.unhook()

    return ...
end

function M.createHookEnableDebugMode()
    hookHandle = bobiny.postHook("init", M.doEnableDebugMode)
end

return M
