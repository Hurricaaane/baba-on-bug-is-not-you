#!/usr/bin/env lua

require('./../game/Data/syntax')
require('./../game/Data/rules')
local biy = require('test/biyfacade')

local biy = biy.Facade:new()

local lu = require('./test/lib/luaunit/luaunit')

TestBasicAssumptions = {}
function TestBasicAssumptions:setUp()
    biy.clear()
end

function TestBasicAssumptions:test_it_should_have_a_features_global_variable()
    -- Exercise
    biy.getDataFeatures()

    -- Verify
    lu.assertEquals({}, biy.getDataFeatures())
end

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
