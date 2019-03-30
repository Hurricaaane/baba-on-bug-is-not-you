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
        return self.overrides[nativeFunctionName][iter].injectFn(function(...)
            return self:recurseOverride(nativeFunctionName, iter - 1, ...)
        end, ...)
    end
end

function BOBINY:createHookFunction(nativeFunctionName)
    return function(...)
        local arguments = table.pack(...)

        for _, preHookInjector in ipairs(self.preHooks[nativeFunctionName]) do
            arguments = table.pack(preHookInjector.injectFn(table.unpack(arguments)))
        end

        local modifiedResult
        local overrideCount = #self.overrides[nativeFunctionName]
        if (overrideCount > 0) then
            modifiedResult = table.pack(self:recurseOverride(nativeFunctionName, overrideCount, table.unpack(arguments)))
        else
            modifiedResult = table.pack(self.native[nativeFunctionName](table.unpack(arguments)))
        end

        for _, postHookInjector in ipairs(self.postHooks[nativeFunctionName]) do
            modifiedResult = table.pack(postHookInjector.injectFn(table.unpack(modifiedResult)))
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

local injectorIdState = 0
local function createInjector(nativeFunctionName, injectFn)
    injectorIdState = injectorIdState + 1

    local currentInjectorId = injectorIdState
    return {
        id = currentInjectorId,
        nativeFunctionName = nativeFunctionName,
        injectFn = injectFn
    }
end

local function removeHookWithInjectorId(hookTable, injectorId)
    for i,_ in ipairs(hookTable) do
        print(hookTable[i].id)
        if (hookTable[i].id == injectorId) then
            table.remove(hookTable, i)
            return
        end
    end
end

local function createHandle(injector, hookTable)
    return {
        unhook = function()
            removeHookWithInjectorId(hookTable[injector.nativeFunctionName], injector.id)
        end
    }
end

function BOBINY.preHook(nativeFunctionName, injectFn)
    local injector = createInjector(nativeFunctionName, injectFn)

    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.preHooks[nativeFunctionName], injector)

    return createHandle(injector, BOBINY.preHooks)
end

function BOBINY.postHook(nativeFunctionName, injectFn)
    local injector = createInjector(nativeFunctionName, injectFn)

    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.postHooks[nativeFunctionName], injector)

    return createHandle(injector, BOBINY.postHooks)
end

function BOBINY.override(nativeFunctionName, injectFn)
    local injector = createInjector(nativeFunctionName, injectFn)

    BOBINY:createHooksIfNotExist(nativeFunctionName)
    table.insert(BOBINY.overrides[nativeFunctionName], injector)

    return createHandle(injector, BOBINY.overrides)
end

function BOBINY.removeAllHooks()
    for nativeFunctionName,nativeFn in pairs(BOBINY.native) do
        _G[nativeFunctionName] = nativeFn
    end
    initializer(BOBINY)
end

return __BOBINY_LIBRARY