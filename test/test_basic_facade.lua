#!/usr/bin/env lua

require('./../game/Data/syntax')
require('./../game/Data/rules')
require('./../game/Data/constants')
require('./../game/Data/load')
require('./../game/Data/values')
require('test/stubs')
local biy = require('test/biyfacade')

local biy = biy.Facade:new()

local lu = require('./test/lib/luaunit/luaunit')

TestBasicAssumptions = {}
function TestBasicAssumptions:setUp()
    biy:runClear()
end
function TestBasicAssumptions:tearDown()
    mmf.forget()
end

function TestBasicAssumptions:test_it_should_have_a_features_global_variable_after_clearing()
    -- Exercise
    biy:setDataFeatures(nil)
    biy:runClear()
    biy:getDataFeatures()

    -- Verify
    lu.assertEquals({}, biy:getDataFeatures())
end

function TestBasicAssumptions:test_it_should_run_native_biy_code_function_without_exception()
    mmf.when.newObject("unknown_id_format_1").thenReturn({values = {}})
    mmf.when.newObject("unknown_id_format_2").thenReturn({values = {}})

    -- Exercise
    biy:runInit({
        generaldataid = "unknown_id_format_1",
        generaldataid2 = "unknown_id_format_2"
    })
    biy:runCode()

    -- Verify
    -- No verification step, the code() function has run without throwing an exception.
end

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
