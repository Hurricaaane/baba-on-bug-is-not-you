local doAssert = require('./test/assertl')

local SUT = require("./game/BobinyLoader/bobiny-loader-modfinder")

local TestBobinyModfinder = {}

function TestBobinyModfinder:setUp()
end

function TestBobinyModfinder:tearDown()
end

function TestBobinyModfinder:test_it_should_only_load_files_that_start_with_mod_underscore_lowercase()
    local bobinyStub = { stub_bobiny_object = true }
    local loadExampleCalledWithLoader = false
    local loadAnotherModCalledWithLoader = false
    local exampleMod = {
        load = function(loader)
            loadExampleCalledWithLoader = loader
        end,
        identifier = "example-mod"
    }
    local anotherMod = {
        load = function(loader)
            loadAnotherModCalledWithLoader = loader
        end,
        identifier = "just-Another-mod"
    }
    SUT.dependencies(function (dependencies)
        dependencies.findFiles = function()
            return { "mod_example.lua", "Mod_uppercase.lua", "notamod.lua", "mod_AnotherMod.lua" }
        end
        dependencies.requireMod = function(path)
            if (path == "./game/BobinyMods/mod_example") then
                return exampleMod
            elseif (path == "./game/BobinyMods/mod_AnotherMod") then
                return anotherMod
            else
                error("Unexpected require mod with path: " .. path)
            end
        end
    end)

    -- Exercise
    local modDescriptors = SUT.loadMods(bobinyStub)

    -- Verify
    doAssert.that(loadExampleCalledWithLoader.path).isEqualTo("./game/BobinyMods/")
    doAssert.that(loadExampleCalledWithLoader.bobiny).isEqualTo(bobinyStub)
    doAssert.that(loadAnotherModCalledWithLoader.path).isEqualTo("./game/BobinyMods/")
    doAssert.that(loadAnotherModCalledWithLoader.bobiny).isEqualTo(bobinyStub)
    doAssert.that(modDescriptors[1].data).isEqualTo(exampleMod)
    doAssert.that(modDescriptors[1].identifier).isEqualTo("example-mod")
    doAssert.that(modDescriptors[1].scriptName).isEqualTo("mod_example")
    doAssert.that(modDescriptors[2].data).isEqualTo(anotherMod)
    doAssert.that(modDescriptors[2].identifier).isEqualTo("just-Another-mod")
    doAssert.that(modDescriptors[2].scriptName).isEqualTo("mod_AnotherMod")
end

return TestBobinyModfinder