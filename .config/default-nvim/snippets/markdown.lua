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
  s('title',
    f(function()
      local file_name = string.gsub(vim.fn.expand('%:t:r'), '_', ' ')
      return '# ' .. string.gsub(file_name, '%f[%l].', string.upper)
    end)
  ),
  s('t',
    t({ '', '- [ ] ' })
  ),
}

-- End snippets

return snippets, autosnippets
