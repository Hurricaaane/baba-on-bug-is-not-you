if (__BOBINY_LIBRARY) then
    return __BOBINY_LIBRARY
end

local function initializer(bobinyObj)
    bobinyObj.native = {}
    bobinyObj.preHooks = {}
    bobinyObj.postHooks = {}
    bobinyObj.overrides = {}
    return bobinyObj
end

__BOBINY_LIBRARY = initializer({})

local BOBINY = __BOBINY_LIBRARY

function BOBINY:recurseOverride(nativeFunctionName, iter, ...)
    if (iter < 1) then
        return self.native[nativeFunctionName](...)
    else
        return self.overrides[nativeFunctionName][iter](function(...)
            return self:recurseOverride(nativeFunctionName, iter - 1, ...)
        end, ...)
    end
end

function BOBINY:createHookFunction(nativeFunctionName)
    return function(...)
        local arguments = table.pack(...)

        for _, preHookFn in ipairs(self.preHooks[nativeFunctionName]) do
            arguments = table.pack(preHookFn(table.unpack(arguments)))
        end

        local modifiedResult
        local overrideCount = #self.overrides[nativeFunctionName]
        if (overrideCount > 0) then
            modifiedResult = table.pack(self:recurseOverride(nativeFunctionName, overrideCount, table.unpack(arguments)))
        else
            modifiedResult = table.pack(self.native[nativeFunctionName](table.unpack(arguments)))
        end

        for _, postHookFn in ipairs(self.postHooks[nativeFunctionName]) do
            modifiedResult = table.pack(postHookFn(table.unpack(modifiedResult)))
        end

        return table.unpack(modifiedResult)
    end
end

function BOBINY:createHooksIfNotExist(nativeFunctionName)
    if (self.native[nativeFunctionName] ~= nil) then
        return
    end

    self.preHooks[nativeFunctionName] = {}
    self.postHooks[nativeFunctionName] = {}
    self.overrides[nativeFunctionName] = {}

    self.native[nativeFunctionName] = _G[nativeFunctionName]
    _G[nativeFunctionName] = self:createHookFunction(nativeFunctionName)
end

function BOBINY.preHook(nativeFunctionName, injectFn)
    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.preHooks[nativeFunctionName], injectFn)
end

function BOBINY.postHook(nativeFunctionName, injectFn)
    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.postHooks[nativeFunctionName], injectFn)
end

function BOBINY.override(nativeFunctionName, injectFn)
    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.overrides[nativeFunctionName], injectFn)
end

function BOBINY.removeAllHooks()
    for nativeFunctionName,nativeFn in pairs(BOBINY.native) do
        _G[nativeFunctionName] = nativeFn
    end
    initializer(BOBINY)
end

return __BOBINY_LIBRARY