if (__BOBINY_LOADER) then
    return __BOBINY_LOADER
end

if (__BOBINY_T) then
    __BOBINY_LOADER = {
        forget = function() end,
        loadNow = function() end,
        loadAfterGameInit = function() end,
        loadBeforeHook = function() end,
        loadAfterHook = function() end
    }
    return __BOBINY_LOADER
end

local M = {}
__BOBINY_LOADER = M

local bobinyPrefix = ""

local _deps = {
    bobiny = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-library"),
    modfinder = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-modfinder")
}

function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

local modsAlreadyLoaded = false
local function doLoadMods()
    if (modsAlreadyLoaded) then
        return
    end
    modsAlreadyLoaded = true

    _deps.modfinder.loadMods(_deps.bobiny)
end

function M.forget()
    modsAlreadyLoaded = false
end

function M.loadNow()
    doLoadMods()
end

function M.loadAfterGameInit()
    M.loadBeforeHook("init")
end

function M.loadBeforeHook(nativeFunctionName)
    local hookHandle
    hookHandle = _deps.bobiny.preHook(nativeFunctionName, function(...)
        doLoadMods()
        hookHandle.unhook()
        return ...
    end)
end

function M.loadAfterHook(nativeFunctionName)
    local hookHandle
    hookHandle = _deps.bobiny.postHook(nativeFunctionName, function(...)
        doLoadMods()
        hookHandle.unhook()
        return ...
    end)
end

return M