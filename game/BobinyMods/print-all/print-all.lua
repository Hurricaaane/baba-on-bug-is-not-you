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

local function toDebugString(arg)
    if (type(arg) == "string") then
        arg = '"' .. arg .. '"'
    end
    return tostring(arg):gsub("\n", "\\n")
end

local function toDebugStringFromTable(tableWithNilValues)
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

local function toFunctionDisplay(functionName, ...)
    local prettyArgs = toDebugStringFromTable(table.pack(...))
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
            _deps.printFn(call .. "\t-> " .. toDebugStringFromTable(result))

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

--local function splitNewlines(input)
--    local t = {}
--    for sub in string.gmatch(input, "([^\n]+)") do
--        table.insert(t, sub)
--    end
--    return t
--end
--
--local function PRLOGS(message)
--    for _,line in ipairs(splitNewlines(message)) do
--        print("#~\t" .. line)
--    end
--end

return M