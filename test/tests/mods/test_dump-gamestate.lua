local doAssert = require('./test/assertl')

local SUT = require("./game/BobinyMods/dump-gamestate/dump-gamestate")

local TestModDumpGamestate = {}

local features
local outputArgument
local outputCallCount
function TestModDumpGamestate:setUp()
    SUT.dependencies(function(dependencies)
        dependencies.mappings = {
            the_features_key = {
                get = function() return features end,
                interval = 1
            }
        }
        dependencies.outputFn = function(output)
            outputArgument = output
            outputCallCount = outputCallCount + 1
        end
    end)
    features = nil
    outputArgument = nil
    outputCallCount = 0
end

function TestModDumpGamestate:tearDown()
    SUT.flushMemory()
end

function TestModDumpGamestate:test_it_should_dump_game_state_on_first_tick()
    features = {
        a = 1,
        b = 2
    }

    -- Exercise
    SUT.effectsTick()

    -- Verify
    doAssert.that(outputCallCount).isEqualTo(1)
    doAssert.that(outputArgument).isEqualTo('#~\t{"the_features_key":{"a":1, "b":2, "array":[]}}')
end

function TestModDumpGamestate:test_it_should_dump_game_state_only_once_per_identical_key()
    features = {
        a = 1,
        b = 2
    }

    -- Exercise
    SUT.doDumpGameState()
    SUT.doDumpGameState()

    -- Verify
    doAssert.that(outputCallCount).isEqualTo(1)
    doAssert.that(outputArgument).isEqualTo('#~\t{"the_features_key":{"a":1, "b":2, "array":[]}}')
end

function TestModDumpGamestate:test_it_should_dump_game_state_after_memory_is_flushed()
    features = {
        c = 3,
        d = 4
    }

    -- Exercise
    SUT.doDumpGameState()
    SUT.flushMemory()
    features = {
        a = 1,
        b = 2
    }
    SUT.doDumpGameState()

    -- Verify
    doAssert.that(outputCallCount).isEqualTo(2)
    doAssert.that(outputArgument).isEqualTo('#~\t{"the_features_key":{"a":1, "b":2, "array":[]}}')
end

function TestModDumpGamestate:test_it_should_dump_arraylike_game_state_as_arrays()
    features = {}
    table.insert(features, "baba")
    table.insert(features, "is")
    table.insert(features, "you")

    -- Exercise
    SUT.doDumpGameState()

    -- Verify
    doAssert.that(outputCallCount).isEqualTo(1)
    doAssert.that(outputArgument).isEqualTo('#~\t{"the_features_key":{"array":["baba","is","you"]}}')
end

function TestModDumpGamestate:test_it_should_dump_empty_table()
    features = { }

    -- Exercise
    SUT.doDumpGameState()

    -- Verify
    doAssert.that(outputCallCount).isEqualTo(1)
    doAssert.that(outputArgument).isEqualTo('#~\t{"the_features_key":{"array":[]}}')
end

return TestModDumpGamestate