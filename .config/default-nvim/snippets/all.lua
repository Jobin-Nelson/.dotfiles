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
  s({ trig = 'now', hidden = true },
    f(function()
      return os.date('%H:%M')
    end)
  ),
  s({ trig = 'today', hidden = true },
    f(function()
      return os.date('%Y-%m-%d')
    end)
  )
}

-- End snippets

return snippets, autosnippets
