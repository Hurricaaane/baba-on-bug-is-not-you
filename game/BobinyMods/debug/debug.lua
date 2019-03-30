local M = {}

local bobiny

function M.setBobiny(bobinyProvided)
    bobiny = bobinyProvided
end

function M.doEnableDebugMode(...)
    generaldata.strings[BUILD] = "debug"

    return ...
end

function M.createHookEnableDebugMode()
    bobiny.postHook("init", M.doEnableDebugMode)
end

return M
