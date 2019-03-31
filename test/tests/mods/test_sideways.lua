local doAssert = require('./test/assertl')

local SUT = require("./game/BobinyMods/sideways/sideways-example")

local TestModSideways = {}

function TestModSideways:setUp()
end

function TestModSideways:tearDown()
end

function TestModSideways:test_it_should_rotate_controls_dir_1()
    -- Exercise
    local ox, oy, dir_, playerid_ = SUT.doSidewaysControls(100, 100, 1, 0)

    -- Verify
    doAssert.that(ox).isEqualTo(-1)
    doAssert.that(oy).isEqualTo(0)
    doAssert.that(dir_).isEqualTo(2)
    doAssert.that(playerid_).isEqualTo(0)
end

function TestModSideways:test_it_should_rotate_controls_dir_3()
    -- Exercise
    local ox, oy, dir_, playerid_ = SUT.doSidewaysControls(100, 100, 3, 0)

    -- Verify
    doAssert.that(ox).isEqualTo(1)
    doAssert.that(oy).isEqualTo(0)
    doAssert.that(dir_).isEqualTo(0)
    doAssert.that(playerid_).isEqualTo(0)
end


function TestModSideways:test_it_should_create_hook()
    local hookNativeFunctionName
    local hookInjectFn
    SUT.dependencies(function(dependencies)
        dependencies.bobiny = {
            preHook = function(nativeFunctionName, injectFn)
                hookNativeFunctionName = nativeFunctionName
                hookInjectFn = injectFn
            end
        }
    end)

    -- Exercise
    SUT.start()
    local ox, oy, dir_, playerid_ = hookInjectFn(100, 100, 1, 0)

    -- Verify
    doAssert.that(hookNativeFunctionName).isEqualTo("movecommand")
    doAssert.that(ox).isEqualTo(-1)
    doAssert.that(oy).isEqualTo(0)
    doAssert.that(dir_).isEqualTo(2)
    doAssert.that(playerid_).isEqualTo(0)
end

return TestModSideways