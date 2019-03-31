local M = {}

local lu = require('./test/lib/luaunit/luaunit')

function M.that(actual)
    return {
        isEqualTo = function(expected)
            lu.assertEquals(actual, expected)
        end
    }
end

return M
