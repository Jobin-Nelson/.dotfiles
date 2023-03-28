return {
    'L3MON4D3/LuaSnip',
    name = 'luasnip',
    lazy = true,
    build = 'make install_jsregexp',
    config = function()
        local ls = require('luasnip')
        require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets/" })
        vim.keymap.set({'i', 's'}, '<C-l>', function() if ls.choice_active() then ls.change_choice(1) end end)
        vim.keymap.set('n', '<leader>sn', require('luasnip.loaders').edit_snippet_files)
        ls.setup({
            history = true,
            updateevents = 'TextChanged,TextChangedI',
            delete_check_events = 'TextChanged',
            enable_autosnippets = false,
            ex_opts = {
                [require('luasnip.util.types').choiceNode] = {
                    active = {
                        virt_text = { { '◀', 'Error' } },
                    }
                }
            }
        })
    end,
}
