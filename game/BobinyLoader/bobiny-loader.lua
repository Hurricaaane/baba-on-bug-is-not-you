if (__BOBINY_LOADER) then
    return __BOBINY_LOADER
end

local M = {}

local bobinyPrefix = ""

local _deps
if (__BOBINY_T) then
    _deps = {}

else
    _deps = {
        bobiny = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-library"),
        modfinder = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-modfinder")
    }
end

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

if (__BOBINY_T) then
    __BOBINY_LOADER = {
        dependencies = function(...)
            if __BOBINY_T_ENTRY then
                M.dependencies(...)
            end
        end,
        forget = function(...)
            if __BOBINY_T_ENTRY then
                M.forget(...)
            end
        end,
        loadNow = function(...)
            if __BOBINY_T_ENTRY then
                M.loadNow(...)
            end
        end,
        loadAfterGameInit = function(...)
            if __BOBINY_T_ENTRY then
                M.loadAfterGameInit(...)
            end
        end,
        loadBeforeHook = function(...)
            if __BOBINY_T_ENTRY then
                M.loadBeforeHook(...)
            end
        end,
        loadAfterHook = function(...)
            if __BOBINY_T_ENTRY then
                M.loadAfterHook(...)
            end
        end
    }
else
    __BOBINY_LOADER = M
end

return __BOBINY_LOADER