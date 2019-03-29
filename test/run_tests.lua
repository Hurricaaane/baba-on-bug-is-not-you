#!/usr/bin/env lua

require('./game/Data/syntax')
require('./game/Data/rules')
require('./game/Data/load')
require('./game/Data/values')
require('./game/Data/metadata')
require('./game/Data/tools')
require('./game/Data/colours')
require('./game/Data/blocks')
require('./game/Data/features')

-- `inspect` is a function. Make it global so that it can be invoked from the debugger.
inspect = require('./test/lib/inspect/inspect')

local lu = require('./test/lib/luaunit/luaunit')

TestBasicAssumptions = require('./test/tests/test_basic_facade')

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
