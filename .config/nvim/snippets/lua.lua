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

local snippets, autosnippets = {}, {}

-- Snippets go here

local myFirstAutoSnippet = s({trig='auto', regTrig=true, hidden=false}, {
    i(1, 'uppercase me'),
    rep(i)
})
table.insert(autosnippets, myFirstAutoSnippet)

-- End snippets

return snippets, autosnippets
