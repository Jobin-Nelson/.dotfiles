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
  s({ trig = 'dmain' },
    fmt([[
def main(){}:
    {}

if __name__ == '__main__':
    {}
]], {
      d(1, function(node)
        if node[1][1] == 'raise SystemExit(main())' then
          return sn(1, t(' -> int'))
        end
        return sn(1, t(' -> None'))
      end, 2),
      i(0, ''),
      c(2, {
        t('raise SystemExit(main())'),
        t('main()'),
        i(1, ''),
      })
    })
  ),
  s({ trig = 'imain', hidden = true },
    t({ "if __name__ == '__main__':", '\t' })
  ),
}

-- End snippets

return snippets, autosnippets
