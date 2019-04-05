#!/usr/bin/env lua

__BOBINY_T = "./game/"

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

TestBasicAssumptions = require('./test/tests/native/test_basic_facade')
TestBobinyEntryPoint = require('./test/tests/bobiny/test_bobiny-loader')
TestBobinyLoaderLibrary = require('./test/tests/bobiny/test_bobiny-loader-library')
TestBobinyModfinder = require('./test/tests/bobiny/test_bobiny-loader-modfinder')
TestModSideways = require('./test/tests/mods/test_sideways')
TestModDebug = require('./test/tests/mods/test_debug')
TestPrintAll = require('./test/tests/mods/test_print-all')
TestModDumpGamestate = require('./test/tests/mods/test_dump-gamestate')

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
