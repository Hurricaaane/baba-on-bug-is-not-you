local M = {}

local _deps = {
    bobiny = nil,
    globals = _G,
    printFn = function(...)
        print(...)
    end
}
function M.dependencies(dependencyFn)
    dependencyFn(_deps)
end

local _toDebugStringFromTable

local function toDebugString(arg)
    if (type(arg) == "string") then
        arg = '"' .. arg .. '"'

    elseif (type(arg) == "table") then
        arg = '{' .. _toDebugStringFromTable(arg) .. '}'
    end

    return tostring(arg):gsub("\n", "\\n")
end

local function toDebugStringFromArrayLikeTable(tableWithNilValues)
    local prettyArgs = ""

    -- Using pairs or ipairs is not possible as it handles nil values differently.
    for i = 1, #tableWithNilValues do
        local prettyArg = toDebugString(tableWithNilValues[i])

        if prettyArgs == "" then
            prettyArgs = prettyArg
        else
            prettyArgs = prettyArgs .. ", " .. prettyArg
        end
    end

    return prettyArgs
end

local function keysSorted(myTable)
    local keys = {}
    for k, _ in pairs(myTable) do
        table.insert(keys, k)
    end

    table.sort(keys)
    return keys
end

local function toDebugStringFromTable(myTable)
    local prettyArgs = ""

    local sortedKeys = keysSorted(myTable)
    for _, key in pairs(sortedKeys) do
        local prettyArg = key .. ' = ' .. toDebugString(myTable[key])

        if prettyArgs == "" then
            prettyArgs = prettyArg
        else
            prettyArgs = prettyArgs .. ", " .. prettyArg
        end
    end

    return prettyArgs
end

_toDebugStringFromTable = toDebugStringFromTable

local function toFunctionDisplay(functionName, ...)
    local prettyArgs = toDebugStringFromArrayLikeTable(table.pack(...))
    return functionName .. "(" .. prettyArgs ..")"
end

local depth = 0
local function scopedOverride(functionName)
    _deps.bobiny.override(functionName, function(super, ...)
        local indentPrefix = "#~\t" .. string.rep(" ", depth)
        local call = indentPrefix .. toFunctionDisplay(functionName, ...)

        depth = depth + 1
        local result = table.pack(super(...))
        depth = depth - 1

        if #result > 0 then
            _deps.printFn(call .. "\t-> " .. toDebugStringFromArrayLikeTable(result))

        else
            _deps.printFn(call)
        end

        return table.unpack(result)
    end)
end

function M.start()
    for globalFunctionName, value in pairs(_deps.globals) do
        if type(value) == "function"
            and globalFunctionName ~= "print"
            and globalFunctionName ~= "type"
            and globalFunctionName ~= "tostring"
            and globalFunctionName ~= "pairs"
            and globalFunctionName ~= "ipairs"
        then
            scopedOverride(globalFunctionName)
        end
    end
end

return M