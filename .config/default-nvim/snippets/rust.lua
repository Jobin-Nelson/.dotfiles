local ls = require('luasnip')
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local autosnippets = {}

-- Snippets go here

local snippets = {
  s({ trig = "ctest", hidden = false },
    fmt([[
#[cfg(test)]
mod tests {{
    #[test]
    fn {}() {{
        {}
    }}
}}
    ]], {
      i(1, "test_1"),
      i(2, "start_testing..."),
    })
  ),
}

-- End snippets

return snippets, autosnippets
