local M = {}

local Facade = {}

function Facade:runClear()
    --[[ Declared in Data/syntax ]]
    clear()
end
function Facade:runCode()
    --[[ Declared in Data/rules ]]
    code()
end
function Facade:runClearUnits()
    --[[ Declared in Data/syntax ]]
    clearunits()
end
function Facade:runInit(argsObj)
    --[[ Declared in Data/syntax]]
    init(argsObj.tilemapid, argsObj.roomsizex_, argsObj.roomsizey_, argsObj.tilesize_, argsObj.Xoffset_, argsObj.Yoffset_, argsObj.generaldataid, argsObj.generaldataid2, argsObj.spritedataid, argsObj.screenw_, argsObj.screenh_)
end

function Facade:getDataFeatures() --[[ Initialized globally through Data/syntax]] return features end
function Facade:setDataFeatures(value) --[[ Initialized globally through Data/syntax]] features = value end

function Facade:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
M.Facade = Facade

return M
