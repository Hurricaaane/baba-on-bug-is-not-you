local M = {}

require('./../game/Data/constants')

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

function Facade:runAddUnit(argsObj)
    --[[ Declared in Data/syntax]]
    addunit(argsObj.id)
end

function Facade:setDataChanges(value)
    --[[ Initialized globally through Data/changes or Data/load]]
    changes = value
end

function Facade:getDataFeatures()
    --[[ Initialized globally through Data/syntax]]
    return features
end

function Facade:setDataFeatures(value)
    --[[ Initialized globally through Data/syntax]]
    features = value
end

function Facade:getDataTileslist()
    --[[ Initialized globally through Data/values]]
    return tileslist
end

function Facade:customGetClassNameByTileName(requestedName)
    --[[ Initialized globally through Data/values]]
    for tileClassName,tileObject in pairs(self:getDataTileslist()) do
        if (tileObject.name == requestedName) then
            return tileClassName
        end
    end

    error("customGetClassNameByTileName: requested className does not exist: " .. requestedName)
end

Facade.constants = {
        online = ONLINE, type = TYPE, tiling = TILING, xpos = XPOS, ypos = YPOS, dir = DIR, effect = EFFECT, effectcount = EFFECTCOUNT, visualdir = VISUALDIR, float = FLOAT, completed = COMPLETED, visuallevel = VISUALLEVEL, visualstyle = VISUALSTYLE, zlayer = ZLAYER, pushed = PUSHED, moved = MOVED, id = ID, positioning = POSITIONING, name = NAME, unittype = UNITTYPE, unitname = UNITNAME, u_levelfile = U_LEVELFILE, u_levelname = U_LEVELNAME, clearcolour = CLEARCOLOUR, colour = COLOUR, wobble = WOBBLE, outline = OUTLINE, maplevel = MAPLEVEL, dead = DEAD, infront = INFRONT, converted = CONVERTED, path_style = PATH_STYLE, path_gate = PATH_GATE, path_requirement = PATH_REQUIREMENT, path_target = PATH_TARGET, mode = MODE, shake = SHAKE, currid = CURRID, tilesize = TILESIZE, roomsizex = ROOMSIZEX, roomsizey = ROOMSIZEY, ineditor = INEDITOR, transitioned = TRANSITIONED, ignore = IGNORE, transitionreason = TRANSITIONREASON, wintimer = WINTIMER, fasttransition = FASTTRANSITION, onlyarrows = ONLYARROWS, world = WORLD, currlevel = CURRLEVEL, levelname = LEVELNAME, parent = PARENT, build = BUILD, levelnumber_name = LEVELNUMBER_NAME, lang = LANG, path_object = PATH_OBJECT, particlemult = PARTICLEMULT, undotooltiptimer = UNDOTOOLTIPTIMER, noplayer = NOPLAYER, roomrotation = ROOMROTATION, undotooltip = UNDOTOOLTIP, inmenu = INMENU, levelwobble = LEVELWOBBLE, zoom = ZOOM, saveslot = SAVESLOT, endinggoing = ENDINGGOING, buttonprompttype = BUTTONPROMPTTYPE, unlock = UNLOCK, unlocktimer = UNLOCKTIMER, mapclear = MAPCLEAR, previouslevel = PREVIOUSLEVEL, turnsound = TURNSOUND, removalsound = REMOVALSOUND, levelsurrounds = LEVELSURROUNDS, music = MUSIC, oldmusic = OLDMUSIC, onlevel = ONLEVEL, spritemult = SPRITEMULT, tilemult = TILEMULT, endphase = ENDPHASE, endtimer = ENDTIMER, endcredits = ENDCREDITS, allisdone = ALLISDONE, introphase = INTROPHASE, introtimer = INTROTIMER, veryfirsttime = VERYFIRSTTIME, xvel = XVEL, yvel = YVEL, xbase = XBASE, ybase = YBASE, notabsolute = NOTABSOLUTE
}

function Facade:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
M.Facade = Facade

return M
