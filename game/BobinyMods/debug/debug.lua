local M = {}

local hookHandle

local _deps = {
    bobiny = nil
}
function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

function M.doEnableDebugMode(...)
    generaldata.strings[BUILD] = "debug"

    hookHandle.unhook()

    return ...
end

function M.start()
    hookHandle = _deps.bobiny.postHook("init", M.doEnableDebugMode)
end

return M
