local M = {}

local lu = require('./test/lib/luaunit/luaunit')

function M.that(actual)
    return {
        isEqualTo = function(expected)
            lu.assertEquals(actual, expected)
        end,
        isTrue = function()
            lu.assertIsTrue(actual)
        end,
        isFalse = function()
            lu.assertIsFalse(actual)
        end
    }
end

return M
