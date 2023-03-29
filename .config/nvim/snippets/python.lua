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
    s({ trig = 'def', hidden = true },
    fmt([[
def main():
    {}

if '__main__' == '__name__':
    {}
]],{i(0, ''),
    c(1, {
        t('raise SystemExit(main())'),
        t('main()'),
        i(1, ''),
        })
    }))
}

-- End snippets

return snippets, autosnippets
