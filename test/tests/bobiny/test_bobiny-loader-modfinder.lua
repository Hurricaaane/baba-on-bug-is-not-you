local assertThat = require('./test/assertl')

local modfinder = require("./game/BobinyLoader/bobiny-loader-modfinder")

local TestBobinyModfinder = {}

function TestBobinyModfinder:setUp()
end

function TestBobinyModfinder:tearDown()
end

function TestBobinyModfinder:test_it_should_only_load_files_that_start_with_mod_underscore_lowercase()
    local bobinyStub = { stub_bobiny_object = true }
    local loadExampleCalledWithLoader = false
    local loadAnotherModCalledWithLoader = false
    modfinder.dependencies(function (dependencies)
        dependencies.findFiles = function()
            return { "mod_example.lua", "Mod_uppercase.lua", "notamod.lua", "mod_AnotherMod.lua" }
        end
        dependencies.requireMod = function(path)
            if (path == "./game/BobinyMods/mod_example") then
                return {
                    load = function(loader)
                        loadExampleCalledWithLoader = loader
                    end
                }
            elseif (path == "./game/BobinyMods/mod_AnotherMod") then
                return {
                    load = function(loader)
                        loadAnotherModCalledWithLoader = loader
                    end
                }
            else
                error("Unexpected require mod with path: " .. path)
            end
        end
    end)

    -- Exercise
    modfinder.loadMods(bobinyStub)

    -- Verify
    assertThat(loadExampleCalledWithLoader.path).isEqualTo("./game/BobinyMods/")
    assertThat(loadExampleCalledWithLoader.bobiny).isEqualTo(bobinyStub)
    assertThat(loadAnotherModCalledWithLoader.path).isEqualTo("./game/BobinyMods/")
    assertThat(loadAnotherModCalledWithLoader.bobiny).isEqualTo(bobinyStub)
end

return TestBobinyModfinder