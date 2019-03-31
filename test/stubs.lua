mmf = {}
mmf.when = {}
function mmf.forget()
    mmf._memory = {}
end
mmf._memory = {}
function mmf.when.newObject(id)
    return {
        thenReturn = function(value)
            mmf._memory.newObject = mmf._memory.newObject or {}
            mmf._memory.newObject[id] = value
        end
    }
end
function mmf.newObject(id)
    return mmf._memory.newObject[id] or {}
end

TileMap = {}
function TileMap.new(tilemapid)
    return {
        ___is_stub = true,
        ___args = {
            tilemapid = tilemapid
        }
    }
end

function MF_removeblockeffect(effect)
    return {
        ___is_stub = true,
        ___args = {
            effect = effect
        }
    }
end
function MF_defaultcolour(unitid)
    return {
        ___is_stub = true,
        ___args = {
            unitid = unitid
        }
    }
end
function MF_setcolour(unitid, colour1, colour2)
    return {
        ___is_stub = true,
        ___args = {
            unitid = unitid,
            colour1 = colour1,
            colour2 = colour2
        }
    }
end
function MF_animframe(id, unknown1)
    return {
        ___is_stub = true,
        ___args = {
            id = id,
            unknown1 = unknown1
        }
    }
end
