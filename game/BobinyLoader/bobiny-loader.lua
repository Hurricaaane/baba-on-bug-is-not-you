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

local bobiny = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-library")

local modfinder = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-modfinder")

local modsAlreadyLoaded = false
local function doLoadMods()
    if (modsAlreadyLoaded) then
        return
    end
    modsAlreadyLoaded = true

    modfinder.loadMods(bobiny)
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
    hookHandle = bobiny.preHook(nativeFunctionName, function(...)
        doLoadMods()
        hookHandle.unhook()
        return ...
    end)
end

function M.loadAfterHook(nativeFunctionName)
    local hookHandle
    hookHandle = bobiny.postHook(nativeFunctionName, function(...)
        doLoadMods()
        hookHandle.unhook()
        return ...
    end)
end

return M