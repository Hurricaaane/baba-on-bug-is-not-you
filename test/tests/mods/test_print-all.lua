local doAssert = require('./test/assertl')

local SUT = require("./game/BobinyMods/print-all/print-all")

local TestPrintAll = {}

local functionNameArgument
local callbackArgument
local printFnArgument
local overrideCount

function TestPrintAll:setUp()
    functionNameArgument = nil
    callbackArgument = nil
    printFnArgument = nil
    overrideCount = 0
end

function TestPrintAll:tearDown()
end

local function injectorGenerator(globals)
    return function(dependencies)
        dependencies.globals = globals
        dependencies.bobiny = {
            override = function(functionName, callback)
                functionNameArgument = functionName
                callbackArgument = callback
                overrideCount = overrideCount + 1
            end
        }
        dependencies.printFn = function(argument)
            printFnArgument = argument
        end
    end
end

function TestPrintAll:test_it_should_override_global_functions()
    local myFunction = function(a)
        return a + 1, nil, "some result"
    end
    local myGlobals = {
        someText = "some text",
        print = function() end,
        type = function() end,
        tostring = function() end,
        pairs = function() end,
        ipairs = function() end,
        myGlobalFunction = myFunction
    }
    SUT.dependencies(injectorGenerator(myGlobals))

    -- Exercise
    SUT.start()

    -- Verify
    doAssert.that(functionNameArgument).isEqualTo("myGlobalFunction")
    doAssert.that(overrideCount).isEqualTo(1)

    -- Exercise, phase 2
    local result = callbackArgument(myFunction, 600)

    -- Verify, phase 2
    doAssert.that(result).isEqualTo(601)
end

function TestPrintAll:test_it_should_print_overriden_function()
    local myFunction = function(a)
        return a + 1, nil, "some result"
    end
    local myGlobals = {
        myGlobalFunction = myFunction
    }
    SUT.dependencies(injectorGenerator(myGlobals))

    -- Exercise
    SUT.start()
    local result = callbackArgument(myFunction, 600, nil, nil, "xyz", true, false, "abc\ndef\tghi", 1.1, nil, nil, nil)

    -- Verify
    -- Only sanitize newlines, not anything else like tabulations.
    doAssert.that(printFnArgument).isEqualTo("#~\tmyGlobalFunction(600, nil, nil, \"xyz\", true, false, \"abc\\ndef\tghi\", 1.1)\t-> 601, nil, \"some result\"")
end

function TestPrintAll:test_it_should_print_overriden_function_that_returns_nothing()
    local myFunction = function(a)
        return
    end
    local myGlobals = {
        myGlobalFunction = myFunction
    }
    SUT.dependencies(injectorGenerator(myGlobals))

    -- Exercise
    SUT.start()
    local result = callbackArgument(myFunction, 600)

    -- Verify
    -- Only sanitize newlines, not anything else like tabulations.
    doAssert.that(printFnArgument).isEqualTo("#~\tmyGlobalFunction(600)")
end

return TestPrintAll