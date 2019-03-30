if (__BOBINY_LIBRARY) then
    return __BOBINY_LIBRARY
end

local function initializer(bobinyObj)
    bobinyObj.native = {}
    bobinyObj.preHooks = {}
    bobinyObj.postHooks = {}
    return bobinyObj
end

__BOBINY_LIBRARY = initializer({})

local BOBINY = __BOBINY_LIBRARY

function BOBINY:createHookFunction(nativeFunctionName)
    return function(...)
        local arguments = table.pack(...)

        for _, preHookFn in ipairs(self.preHooks[nativeFunctionName]) do
            arguments = table.pack(preHookFn(table.unpack(arguments)))
        end

        local modifiedResult = table.pack(self.native[nativeFunctionName](table.unpack(arguments)))

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

function BOBINY.removeAllHooks()
    for nativeFunctionName,nativeFn in pairs(BOBINY.native) do
        _G[nativeFunctionName] = nativeFn
    end
    initializer(BOBINY)
end

return __BOBINY_LIBRARY