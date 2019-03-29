local M = {}

local lu = require('./test/lib/luaunit/luaunit')

function M.assertThat(actual)
    return {
        isEqualTo = function(expected)
            lu.assertEquals(actual, expected)
        end
    }
end

setmetatable(M, { __call = function(_, ...) return M.assertThat(...) end })

return M
