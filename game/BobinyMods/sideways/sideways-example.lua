local M = {}

local _deps = {
    bobiny = nil
}
function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

function M.doSidewaysControls(ox, oy, dir_, playerid_)
    local isIdle = dir_ == 4
    if (isIdle) then
        return ox, oy, dir_, playerid_
    else
        local newDir = (dir_ + 1) % 4
        local newCoords = ndirs[1 + newDir]
        return newCoords[1], newCoords[2], newDir, playerid_
    end
end

function M.createHookSidewaysControls()
    _deps.bobiny.preHook("movecommand", M.doSidewaysControls)
end

return M