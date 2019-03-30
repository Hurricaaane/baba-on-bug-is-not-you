if (__BOBINY_LOADER) then
    return
end
__BOBINY_LOADER = true

require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader-library")
require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader-example")
