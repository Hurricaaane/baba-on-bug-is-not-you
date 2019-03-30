require('./test/stubs')
local biyLib = require('./test/biyfacade')

local biy = biyLib.BIY:new()

local lu = require('./test/lib/luaunit/luaunit')
local assertThat = require('./test/assertl')

local TestBasicAssumptions = {}
function TestBasicAssumptions:setUp()
    biy:runClear()
end
function TestBasicAssumptions:tearDown()
    mmf.forget()
end

local function generate(generatorFn)
    local obj = {}
    generatorFn(obj)
    return obj
end

function TestBasicAssumptions:test_it_should_have_a_features_global_variable_after_clearing()
    -- Exercise
    biy:setDataFeatures(nil)
    biy:runClear()
    biy:getDataFeatures()

    -- Verify
    lu.assertEquals({}, biy:getDataFeatures())
end

function TestBasicAssumptions:test_it_should_run_native_biy_code_without_exception()
    mmf.when.newObject("unknown_id_format_1").thenReturn({values = {}})
    mmf.when.newObject("unknown_id_format_2").thenReturn({values = {}})

    -- Exercise
    biy:runInit({
        generaldataid = "unknown_id_format_1",
        generaldataid2 = "unknown_id_format_2"
    })
    biy:runCode()

    -- Verify
    -- No verification step, the runCode() function has run without throwing an exception.
end

function TestBasicAssumptions:test_it_should_get_a_class_name_by_name()
    -- Exercise
    local className = biy:customGetClassNameByTileName("baba")

    -- Verify
    assertThat(className).isEqualTo("object000")
end

function TestBasicAssumptions:test_it_should_run_native_biy_add_unit_without_exception()
    mmf.when.newObject("unknown_id_format_1").thenReturn({values = {}})
    mmf.when.newObject("unknown_id_format_2").thenReturn({values = {}})
    local unit = {
        className = biy:customGetClassNameByTileName("baba"),
        values = generate(function(obj)
            obj[biy.constants.xpos] = 0
            obj[biy.constants.ypos] = 0
            obj[biy.constants.float] = 0
        end),
        strings = {},
        fixed = "some_unit_fixed_id"
    }
    mmf.when.newObject("some_unit_fixed_id").thenReturn(unit)

    -- Exercise
    biy:runInit({
        generaldataid = "unknown_id_format_1",
        generaldataid2 = "unknown_id_format_2"
    })
    biy:setDataChanges({})
    biy:runAddUnit({id = "some_unit_fixed_id"})

    -- Verify
    -- No verification step, the runAddUnit() function has run without throwing an exception.
end

return TestBasicAssumptions