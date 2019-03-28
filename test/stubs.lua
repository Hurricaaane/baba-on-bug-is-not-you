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
        __tilemapid = tilemapid
    }
end

function MF_removeblockeffect(effect)
    return {
        ___is_stub = true,
        __effect = effect
    }
end