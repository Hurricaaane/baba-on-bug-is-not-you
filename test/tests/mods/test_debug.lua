local assertThat = require('./test/assertl')

local SUT = require("./game/BobinyMods/debug/debug")

local TestModDebug = {}

local previousValue
function TestModDebug:setUp()
    if (generaldata == nil) then
        generaldata = {}
    end
    if (generaldata.strings == nil) then
        generaldata.strings = {}
    end

    previousValue = generaldata.strings[BUILD]
end

function TestModDebug:tearDown()
    generaldata.strings[BUILD] = previousValue
end

function TestModDebug:test_it_should_enable_debug_mode()
    -- Exercise
    SUT.doEnableDebugMode()

    -- Verify
    assertThat(generaldata.strings[BUILD]).isEqualTo("debug")
end

function TestModDebug:test_it_should_create_hook()
    local hookNativeFunctionName
    local hookInjectFn
    local unhookCalled = false
    SUT.dependencies(function(dependencies)
        dependencies.bobiny = {
            postHook = function(nativeFunctionName, injectFn)
                hookNativeFunctionName = nativeFunctionName
                hookInjectFn = injectFn

                return {
                    unhook = function()
                        unhookCalled = true
                    end
                }
            end
        }
    end)

    -- Exercise
    SUT.start()
    hookInjectFn()

    -- Verify
    assertThat(hookNativeFunctionName).isEqualTo("init")
    assertThat(generaldata.strings[BUILD]).isEqualTo("debug")
    assertThat(unhookCalled).isEqualTo(true)
end

return TestModDebug