local bobiny = require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader-library")

bobiny.preHook("movecommand", function(ox, oy, dir_, playerid_)
    local isIdle = dir_ == 4
    if (isIdle) then
        return ox, oy, dir_, playerid_
    else
        local newDir = (dir_ + 1) % 4
        local newCoords = ndirs[1 + newDir]
        return newCoords[1], newCoords[2], newDir, playerid_
    end
end)
