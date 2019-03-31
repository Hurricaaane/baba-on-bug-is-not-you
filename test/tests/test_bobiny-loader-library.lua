local assertThat = require('./test/assertl')

local bobiny = require("./game/BobinyLoader/bobiny-loader-library")

local lastCall
local callCount
local TestBobinyLoaderLibrary = {}

local FIXTURES = {
    anObjWithBehavior = function()
        return {
            someInnerObject = {
                someInnerFn = function(a, b, c)
                    lastCall = { a, b, c }
                    callCount = callCount + 1
                    return "d", "e", "f"
                end
            }
        }
    end
}

function TestBobinyLoaderLibrary:setUp()
    lastCall = nil
    callCount = 0
    __GLOBAL_FUNCTION = function(a, b, c)
        lastCall = { a, b, c }
        callCount = callCount + 1
        return "d", "e", "f"
    end
end

function TestBobinyLoaderLibrary:tearDown()
    __GLOBAL_FUNCTION = nil
    bobiny.removeAllHooks()
end

function TestBobinyLoaderLibrary:test_it_should_pre_hook_on_global_function()
    -- Exercise
    bobiny.preHook("__GLOBAL_FUNCTION", function(a, b, c)
        return a .. 1, b .. 2, c .. 3
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a1")
    assertThat(lastCall[2]).isEqualTo("b2")
    assertThat(lastCall[3]).isEqualTo("c3")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")

end

function TestBobinyLoaderLibrary:test_it_should_post_hook_on_global_function()
    -- Exercise
    bobiny.postHook("__GLOBAL_FUNCTION", function(d, e, f)
        return d .. 4, e .. 5, f .. 6
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d4")
    assertThat(e).isEqualTo("e5")
    assertThat(f).isEqualTo("f6")
end

function TestBobinyLoaderLibrary:test_it_should_override_on_global_function()
    -- Exercise
    bobiny.override("__GLOBAL_FUNCTION", function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a1")
    assertThat(lastCall[2]).isEqualTo("b2")
    assertThat(lastCall[3]).isEqualTo("c3")
    assertThat(d).isEqualTo("d4")
    assertThat(e).isEqualTo("e5")
    assertThat(f).isEqualTo("f6")

end

function TestBobinyLoaderLibrary:test_it_should_remove_all_hooks_on_global_function()
    -- Exercise
    bobiny.preHook("__GLOBAL_FUNCTION", function(a, b, c)
        return a .. 1, b .. 2, c .. 3
    end)
    bobiny.postHook("__GLOBAL_FUNCTION", function(d, e, f)
        return d .. 4, e .. 5, f .. 6
    end)
    bobiny.override("__GLOBAL_FUNCTION", function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    bobiny.removeAllHooks()
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")
end

function TestBobinyLoaderLibrary:test_it_should_remove_all_hooks_on_deep_overrides()
    local objWithBehavior = FIXTURES.anObjWithBehavior()

    -- Exercise
    bobiny.deepOverride({
        get = function() return objWithBehavior.someInnerObject.someInnerFn end,
        set = function(valueFn) objWithBehavior.someInnerObject.someInnerFn = valueFn end

    }, function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    bobiny.removeAllHooks()
    local d, e, f = objWithBehavior.someInnerObject.someInnerFn("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")
end


function TestBobinyLoaderLibrary:test_it_should_multi_pre_hook_on_global_function_in_order()
    -- Exercise
    bobiny.preHook("__GLOBAL_FUNCTION", function(a, b, c)
        return a .. 1, b .. 2, c .. 3
    end)
    bobiny.preHook("__GLOBAL_FUNCTION", function(a, b, c)
        return a .. 4, b .. 5, c .. 6
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a14")
    assertThat(lastCall[2]).isEqualTo("b25")
    assertThat(lastCall[3]).isEqualTo("c36")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")

end

function TestBobinyLoaderLibrary:test_it_should_multi_post_hook_on_global_function_in_order()
    -- Exercise
    bobiny.postHook("__GLOBAL_FUNCTION", function(d, e, f)
        return d .. 4, e .. 5, f .. 6
    end)
    bobiny.postHook("__GLOBAL_FUNCTION", function(d, e, f)
        return d .. 7, e .. 8, f .. 9
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d47")
    assertThat(e).isEqualTo("e58")
    assertThat(f).isEqualTo("f69")
end

function TestBobinyLoaderLibrary:test_it_should_multi_override_on_global_function_with_last_overrides_wrapping_previous_overrides()
    -- Exercise
    bobiny.override("__GLOBAL_FUNCTION", function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    bobiny.override("__GLOBAL_FUNCTION", function(super, a, b, c)
        local d, e, f = super(a .. "x", b .. "y", c .. "z")
        return d .. "u", e .. "v", f .. "w"
    end)
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("ax1")
    assertThat(lastCall[2]).isEqualTo("by2")
    assertThat(lastCall[3]).isEqualTo("cz3")
    assertThat(d).isEqualTo("d4u")
    assertThat(e).isEqualTo("e5v")
    assertThat(f).isEqualTo("f6w")

end

function TestBobinyLoaderLibrary:test_it_should_override_deep()
    local objWithBehavior = FIXTURES.anObjWithBehavior()

    -- Exercise
    bobiny.deepOverride({
        get = function() return objWithBehavior.someInnerObject.someInnerFn end,
        set = function(valueFn) objWithBehavior.someInnerObject.someInnerFn = valueFn end

    }, function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    local d, e, f = objWithBehavior.someInnerObject.someInnerFn("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a1")
    assertThat(lastCall[2]).isEqualTo("b2")
    assertThat(lastCall[3]).isEqualTo("c3")
    assertThat(d).isEqualTo("d4")
    assertThat(e).isEqualTo("e5")
    assertThat(f).isEqualTo("f6")
end


function TestBobinyLoaderLibrary:test_it_should_unhook_with_handle()
    -- Exercise
    local preHookHandle = bobiny.preHook("__GLOBAL_FUNCTION", function(a, b, c)
        return a .. 1, b .. 2, c .. 3
    end)
    local postHookHandle = bobiny.postHook("__GLOBAL_FUNCTION", function(d, e, f)
        return d .. 4, e .. 5, f .. 6
    end)
    local overrideHandle = bobiny.override("__GLOBAL_FUNCTION", function(super, a, b, c)
        local d, e, f = super(a .. "x", b .. "y", c .. "z")
        return d .. "u", e .. "v", f .. "w"
    end)
    preHookHandle.unhook()
    postHookHandle.unhook()
    overrideHandle.unhook()
    local d, e, f = __GLOBAL_FUNCTION("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")

end

function TestBobinyLoaderLibrary:test_it_should_unhook_override_deep()
    local objWithBehavior = FIXTURES.anObjWithBehavior()

    -- Exercise
    local handle = bobiny.deepOverride({
        get = function() return objWithBehavior.someInnerObject.someInnerFn end,
        set = function(valueFn) objWithBehavior.someInnerObject.someInnerFn = valueFn end

    }, function(super, a, b, c)
        local d, e, f = super(a .. 1, b .. 2, c .. 3)
        return d .. 4, e .. 5, f .. 6
    end)
    handle.unhook()
    local d, e, f = objWithBehavior.someInnerObject.someInnerFn("a", "b", "c")

    -- Verify
    assertThat(callCount).isEqualTo(1)
    assertThat(lastCall[1]).isEqualTo("a")
    assertThat(lastCall[2]).isEqualTo("b")
    assertThat(lastCall[3]).isEqualTo("c")
    assertThat(d).isEqualTo("d")
    assertThat(e).isEqualTo("e")
    assertThat(f).isEqualTo("f")
end

return TestBobinyLoaderLibrary