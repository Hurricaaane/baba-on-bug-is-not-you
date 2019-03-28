local M = {}

local Facade = {}
function Facade:clear() --[[ In Data/rules]] clear() end
function Facade:getDataFeatures() --[[ In Data/rules]] return features end
function Facade:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
M.Facade = Facade

return M
