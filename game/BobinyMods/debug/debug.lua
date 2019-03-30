local M = {}

local bobiny = require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader-library")

function M.doEnableDebugMode(...)
    generaldata.strings[BUILD] = "debug"

    return ...
end

function M.createHookEnableDebugMode()
    bobiny.postHook("init", M.doEnableDebugMode)
end

return M
