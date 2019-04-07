local M = {}

local hookHandle
local memory = {}
local dumpCount = 0
local tickCount = 0

local unitsFn = function(unit) return {
    --vONLINE = unit.values[1],
    --vTYPE = unit.values[2],
    --vTILING = unit.values[3],
    vXPOS = unit.values[4],
    vYPOS = unit.values[5],
    --vDIR = unit.values[6],
    --vEFFECT = unit.values[7],
    --vEFFECTCOUNT = unit.values[8],
    --vA = unit.values[9],
    --vVISUALDIR = unit.values[10],
    --vFLOAT = unit.values[11],
    --vCOMPLETED = unit.values[12],
    --vVISUALLEVEL = unit.values[13],
    --vVISUALSTYLE = unit.values[14],
    --vZLAYER = unit.values[15],
    --
    --vPUSHED = unit.values[19],
    --vMOVED = unit.values[20],
    --vID = unit.values[21],
    --vPOSITIONING = unit.values[22],
    --vMISC_A = unit.values[23],
    --vMISC_B = unit.values[24],
    --sNAME = unit.strings[1],
    --sUNITTYPE = unit.strings[2],
    sUNITNAME = unit.strings[3],
    --sU_LEVELFILE = unit.strings[4],
    --sU_LEVELNAME = unit.strings[5],
    --
    --sCLEARCOLOUR = unit.strings[9],
    --sCOLOUR = unit.strings[10],
    --fWOBBLE = unit.flags[12],
    --fOUTLINE = unit.flags[13],
    --fMAPLEVEL = unit.flags[14],
    --fDEAD = unit.flags[15],
    --fINFRONT = unit.flags[16],
    --fCONVERTED = unit.flags[17],
} end

local _deps  = {
    bobiny = nil,
    mappings = {
        features = {
            get = function() return features end,
            interval = 1
        },
        units = {
            get = function()
                local newUnits = {}
                for _, unit in pairs(units) do
                    table.insert(newUnits, unitsFn(unit))
                end
                return newUnits
            end,
            interval = 1
        }
    },
    outputFn = print,
    mmfAccessFn = nil
}

function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

----

local _toJsonStringFromTableOrArray

local function toJsonString(arg)
    if (type(arg) == "string") then
        arg = '"' .. arg .. '"'

    elseif (type(arg) == "table") then
        arg = _toJsonStringFromTableOrArray(arg)
    end

    return tostring(arg)
            :gsub("\n", "\\n")
            :gsub('"', '\"')
end

local function keysSorted(myTable)
    local keys = {}
    for k, _ in pairs(myTable) do
        table.insert(keys, k)
    end

    table.sort(keys)
    return keys
end

local function nativeObjectToJsonString(myTable)
    local prettyArgs = ""
    local sortedKeys = keysSorted(myTable)
    for _, key in pairs(sortedKeys) do
        local prettyArg = '"' .. key .. '":' .. toJsonString(myTable[key])

        if prettyArgs == "" then
            prettyArgs = prettyArg
        else
            prettyArgs = prettyArgs .. ", " .. prettyArg
        end
    end

    if (prettyArgs == "") then
        return '{"array":[]}'
    else
        return '{' .. prettyArgs .. ', "array":[]}'
    end
end

local function mmfSubObjectToJsonString(myTable)
    local prettyArgs = ""
    local i = 1
    while myTable[i] ~= nil do
        print("#~\t" .. tostring(myTable[i]))
        local prettyArg = '"' .. i .. '":' .. toJsonString(myTable[i])

        if prettyArgs == "" then
            prettyArgs = prettyArg
        else
            prettyArgs = prettyArgs .. ", " .. prettyArg
        end
        i = i + 1
    end

    if (prettyArgs == "") then
        return '{"array":[]}'
    else
        return '{' .. prettyArgs .. ', "array":[]}'
    end
end

local function mmfObjectToJsonString(myTable)
    local strings = mmfSubObjectToJsonString(myTable.strings)
    local prettyArgs = '"strings":' .. strings

    if (prettyArgs == "") then
        return '{"array":[]}'
    else
        return '{' .. prettyArgs .. ', "array":[]}'
    end
end

local function objectToJsonString(myTable)
    --if (myTable.strings == nil) then
        return nativeObjectToJsonString(myTable)

    --else
        -- Some Lua objects do not behave normally:
        -- - Iterating with pairs() yields no results
        -- - Iterating with ipairs() raises an error
        --return mmfObjectToJsonString(myTable)
    --end
end

local function arrayToJsonString(myArray)
    local arrayValues = ""
    for _, arrayValue in ipairs(myArray) do
        if arrayValues == "" then
            arrayValues = toJsonString(arrayValue)
        else
            arrayValues = arrayValues .. "," .. toJsonString(arrayValue)
        end
    end
    return '{"array":[' .. arrayValues .. "]}"
end

local function toJsonStringFromObjectOrArray(unknownTable)
    local tableSize = #unknownTable
    if (tableSize == 0 or unknownTable[tableSize] == nil) then
        return objectToJsonString(unknownTable)

    else
        return arrayToJsonString(unknownTable)
    end
end

_toJsonStringFromTableOrArray = toJsonStringFromObjectOrArray
----


local function indexer(key, value)
    if (memory[key] == value) then
        return
    end
    memory[key] = value
    _deps.outputFn('#~\t{"' .. key .. '":' .. value .. '}')
end

function M.flushMemory()
    memory = {}
    dumpCount = 0
    tickCount = 0
end

function M.doDumpGameState()
    for index, mapping in pairs(_deps.mappings) do
        if (dumpCount % mapping.interval == 0) then
            indexer(index, toJsonString(mapping.get()))
        end
    end
    dumpCount = dumpCount + 1;
end

function M.effectsTick(...)
    if (tickCount % 10 == 0) then
        M.doDumpGameState()
    end
    tickCount = tickCount + 1;

    return ...
end

function M.start()
    hookHandle = _deps.bobiny.postHook("effects", M.effectsTick)
end

return M
