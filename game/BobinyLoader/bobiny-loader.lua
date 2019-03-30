if (__BOBINY_LOADER) then
    return
end
__BOBINY_LOADER = true

if (__BOBINY_T) then
    return
end

local bobinyPrefix = ""

require(bobinyPrefix .. "BobinyLoader/bobiny-loader-library")
local modfinder = require(bobinyPrefix .. "BobinyLoader/bobiny-loader-modfinder")
modfinder.loadMods()
