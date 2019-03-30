local assertThat = require('./test/assertl')

local modfinder = require("./game/BobinyLoader/bobiny-loader-modfinder")

local TestBobinyModfinder = {}

function TestBobinyModfinder:setUp()
end

function TestBobinyModfinder:tearDown()
end

function TestBobinyModfinder:test_it_should_only_load_files_that_start_with_mod_underscore_lowercase()
    local loadExampleCalled = false
    local loadAnotherModCalled = false
    modfinder._findFiles = function()
        return { "mod_example.lua", "Mod_uppercase.lua", "notamod.lua", "mod_AnotherMod.lua" }
    end
    modfinder._requireMod = function(path)
        if (path == "./game/BobinyMods/mod_example") then
            return {
                load = function()
                    loadExampleCalled = true
                end
            }
        elseif (path == "./game/BobinyMods/mod_AnotherMod") then
            return {
                load = function()
                    loadAnotherModCalled = true
                end
            }
        else
            error("Unexpected require mod with path: " .. path)
        end
    end

    -- Exercise
    modfinder.loadMods()

    -- Verify
    assertThat(loadExampleCalled).isEqualTo(true)
    assertThat(loadAnotherModCalled).isEqualTo(true)
end

return TestBobinyModfinder