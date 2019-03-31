local doAssert = require('./test/assertl')

require('./test/stubs')

local biyLib = require('./test/biyfacade')

local SUT = biyLib.BIY:new()

local TestBasicAssumptions = {}

local mmfMock = mmf

function TestBasicAssumptions:setUp()
    SUT:runClear()
end

function TestBasicAssumptions:tearDown()
    mmfMock.forget()
end

local function generate(generatorFn)
    local obj = {}
    generatorFn(obj)
    return obj
end

function TestBasicAssumptions:test_it_should_have_a_features_global_variable_after_clearing()
    -- Exercise
    SUT:setDataFeatures(nil)
    SUT:runClear()
    local result = SUT:getDataFeatures()

    -- Verify
    doAssert.that(result).isEqualTo({})
end

function TestBasicAssumptions:test_it_should_run_native_biy_code_without_exception()
    mmfMock.when.newObject("unknown_id_format_1").thenReturn({values = {}})
    mmfMock.when.newObject("unknown_id_format_2").thenReturn({values = {}})

    -- Exercise
    SUT:runInit({
        generaldataid = "unknown_id_format_1",
        generaldataid2 = "unknown_id_format_2"
    })
    SUT:runCode()

    -- Verify
    -- No verification step, the runCode() function has run without throwing an exception.
end

function TestBasicAssumptions:test_it_should_get_a_class_name_by_name()
    -- Exercise
    local className = SUT:customGetClassNameByTileName("baba")

    -- Verify
    doAssert.that(className).isEqualTo("object000")
end

function TestBasicAssumptions:test_it_should_run_native_biy_add_unit_without_exception()
    mmfMock.when.newObject("unknown_id_format_1").thenReturn({values = {}})
    mmfMock.when.newObject("unknown_id_format_2").thenReturn({values = {}})
    local unit = {
        className = SUT:customGetClassNameByTileName("baba"),
        values = generate(function(obj)
            obj[SUT.constants.xpos] = 0
            obj[SUT.constants.ypos] = 0
            obj[SUT.constants.float] = 0
        end),
        strings = {},
        fixed = "some_unit_fixed_id"
    }
    mmfMock.when.newObject("some_unit_fixed_id").thenReturn(unit)

    -- Exercise
    SUT:runInit({
        generaldataid = "unknown_id_format_1",
        generaldataid2 = "unknown_id_format_2"
    })
    SUT:setDataChanges({})
    SUT:runAddUnit({id = "some_unit_fixed_id"})

    -- Verify
    -- No verification step, the runAddUnit() function has run without throwing an exception.
end

return TestBasicAssumptions