local assertThat = require('./test/assertl')

local bobinyEntryPoint = require("./game/BobinyLoader/bobiny-loader")

local TestBobinyEntryPoint = {}

function TestBobinyEntryPoint:setUp()
    __BOBINY_T_ENTRY = true
end

function TestBobinyEntryPoint:tearDown()
    bobinyEntryPoint.forget()
    __BOBINY_T_ENTRY = false
end

function TestBobinyEntryPoint:test_it_should_load_now_only_once()
    local bobinyStub = { stub_bobiny = true }
    local loadModsCallCount = 0
    local loadModsCallArgument
    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadNow()
    bobinyEntryPoint.loadNow()

    -- Verify
    assertThat(loadModsCallCount).isEqualTo(1)
    assertThat(loadModsCallArgument).isEqualTo(bobinyStub)
end

function TestBobinyEntryPoint:test_it_should_load_now_twice_if_forgotten()
    local bobinyStub = { stub_bobiny = true }
    local loadModsCallCount = 0
    local loadModsCallArgument
    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadNow()
    bobinyEntryPoint.forget()
    bobinyEntryPoint.loadNow()

    -- Verify
    assertThat(loadModsCallCount).isEqualTo(2)
    assertThat(loadModsCallArgument).isEqualTo(bobinyStub)
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
    local loadModsCallCount = 0
    local loadModsCallArgument
    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadAfterGameInit()
    preHookCallInjectFn("ignored")

    -- Verify
    assertThat(loadModsCallCount).isEqualTo(1)
    assertThat(loadModsCallArgument).isEqualTo(bobinyStub)
    assertThat(preHookCallNativeFunctionName).isEqualTo("init")
    assertThat(unhookCalled).isEqualTo(true)
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
    local loadModsCallCount = 0
    local loadModsCallArgument
    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadBeforeHook("some_function_name")
    preHookCallInjectFn("ignored")

    -- Verify
    assertThat(loadModsCallCount).isEqualTo(1)
    assertThat(loadModsCallArgument).isEqualTo(bobinyStub)
    assertThat(preHookCallNativeFunctionName).isEqualTo("some_function_name")
    assertThat(unhookCalled).isEqualTo(true)
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
    local loadModsCallCount = 0
    local loadModsCallArgument
    bobinyEntryPoint.dependencies(function(dependencies)
        dependencies.bobiny = bobinyStub
        dependencies.modfinder = {
            loadMods = function(bobiny)
                loadModsCallCount = loadModsCallCount + 1
                loadModsCallArgument = bobiny
            end
        }
    end)

    -- Exercise
    bobinyEntryPoint.loadAfterHook("some_function_name")
    postHookCallInjectFn("ignored")

    -- Verify
    assertThat(loadModsCallCount).isEqualTo(1)
    assertThat(loadModsCallArgument).isEqualTo(bobinyStub)
    assertThat(postHookCallNativeFunctionName).isEqualTo("some_function_name")
    assertThat(unhookCalled).isEqualTo(true)
end

return TestBobinyEntryPoint