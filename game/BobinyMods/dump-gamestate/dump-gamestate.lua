local M = {}

local hookHandle

local _deps = {
    bobiny = nil,
    featuresFn = function() return features end,
    outputFn = print
}
function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

----

local _toJsonStringFromTable

local function toJsonString(arg)
    if (type(arg) == "string") then
        arg = '"' .. arg .. '"'

    elseif (type(arg) == "table") then
        arg = '{' .. _toJsonStringFromTable(arg) .. '}'
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

local function tableToJsonString(myTable)
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

    return prettyArgs
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
    return '"array":[' .. arrayValues .. "]"
end

local function toJsonStringFromUnknownTable(unknownTable)
    if (unknownTable[#unknownTable] ~= nil) then
        return arrayToJsonString(unknownTable)
    else
        return tableToJsonString(unknownTable)
    end
end

_toJsonStringFromTable = toJsonStringFromUnknownTable
----

local memory = {}
local function indexer(key, value)
    if (memory[key] == value) then
        return
    end
    memory[key] = value
    _deps.outputFn('#~\t{"' .. key .. '":' .. value .. '}')
end

function M.flushMemory()
    memory = {}
end

function M.doDumpGameState()
    indexer("features", toJsonString(_deps.featuresFn()))
end

local tickCount = 0
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
