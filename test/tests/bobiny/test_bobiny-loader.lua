local doAssert = require('./test/assertl')

local bobinyEntryPoint = require("./game/BobinyLoader/bobiny-loader")

local TestBobinyEntryPoint = {}

local loadModsCallCount
local loadModsCallArgument

local function dependenciesWithStub(bobinyStub)
    return function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
                return {}
            end
        }
    end
end

function TestBobinyEntryPoint:setUp()
    __BOBINY_T_ENTRY = true

    loadModsCallCount = 0
    loadModsCallArgument = nil
end

function TestBobinyEntryPoint:tearDown()
    bobinyEntryPoint.forget()
    __BOBINY_T_ENTRY = false
end

function TestBobinyEntryPoint:test_it_should_load_now_only_once()
    local bobinyStub = { stub_bobiny = true }
    bobinyEntryPoint.dependencies(dependenciesWithStub(bobinyStub))

    -- Exercise
    bobinyEntryPoint.loadNow()
    bobinyEntryPoint.loadNow()

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(1)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
end

function TestBobinyEntryPoint:test_it_should_load_now_twice_if_forgotten()
    local bobinyStub = { stub_bobiny = true }
    bobinyEntryPoint.dependencies(dependenciesWithStub(bobinyStub))

    -- Exercise
    bobinyEntryPoint.loadNow()
    bobinyEntryPoint.forget()
    bobinyEntryPoint.loadNow()

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(2)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
end

function TestBobinyEntryPoint:test_it_should_load_after_game_init()
    local preHookCallNativeFunctionName
    local preHookCallInjectFn
    local unhookCalled = false
    local bobinyStub = {
        preHook = function(nativeFunctionName, injectFn)
            preHookCallNativeFunctionName = nativeFunctionName
            preHookCallInjectFn = injectFn

            return {
                unhook = function()
                    unhookCalled = true
                end
            }
        end
    }
    bobinyEntryPoint.dependencies(dependenciesWithStub(bobinyStub))

    -- Exercise
    bobinyEntryPoint.loadAfterGameInit()
    preHookCallInjectFn("ignored")

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(1)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
    doAssert.that(preHookCallNativeFunctionName).isEqualTo("init")
    doAssert.that(unhookCalled).isEqualTo(true)
end

function TestBobinyEntryPoint:test_it_should_load_before_hook()
    local preHookCallNativeFunctionName
    local preHookCallInjectFn
    local unhookCalled = false
    local bobinyStub = {
        preHook = function(nativeFunctionName, injectFn)
            preHookCallNativeFunctionName = nativeFunctionName
            preHookCallInjectFn = injectFn

            return {
                unhook = function()
                    unhookCalled = true
                end
            }
        end
    }
    bobinyEntryPoint.dependencies(dependenciesWithStub(bobinyStub))

    -- Exercise
    bobinyEntryPoint.loadBeforeHook("some_function_name")
    preHookCallInjectFn("ignored")

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(1)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
    doAssert.that(preHookCallNativeFunctionName).isEqualTo("some_function_name")
    doAssert.that(unhookCalled).isEqualTo(true)
end

function TestBobinyEntryPoint:test_it_should_load_after_hook()
    local postHookCallNativeFunctionName
    local postHookCallInjectFn
    local unhookCalled = false
    local bobinyStub = {
        postHook = function(nativeFunctionName, injectFn)
            postHookCallNativeFunctionName = nativeFunctionName
            postHookCallInjectFn = injectFn

            return {
                unhook = function()
                    unhookCalled = true
                end
            }
        end
    }
    bobinyEntryPoint.dependencies(dependenciesWithStub(bobinyStub))

    -- Exercise
    bobinyEntryPoint.loadAfterHook("some_function_name")
    postHookCallInjectFn("ignored")

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(1)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
    doAssert.that(postHookCallNativeFunctionName).isEqualTo("some_function_name")
    doAssert.that(unhookCalled).isEqualTo(true)
end

function TestBobinyEntryPoint:test_it_should_load_and_then_call_all_mods_loaded()
    local bobinyStub = { stub_bobiny = true }
    local modDescriptors = {}
    local onAllModsLoadedArgument
    table.insert(modDescriptors, {
        data = {
            onAllModsLoaded = function(argument)
                onAllModsLoadedArgument = argument
            end
        }
    })
    table.insert(modDescriptors, {
        data = {
            onAllModsLoaded = nil
        }
    })

    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
                return modDescriptors
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadNow()

    -- Verify
    doAssert.that(loadModsCallCount).isEqualTo(1)
    doAssert.that(loadModsCallArgument).isEqualTo(bobinyStub)
    doAssert.that(onAllModsLoadedArgument).isEqualTo(modDescriptors)
end

return TestBobinyEntryPoint