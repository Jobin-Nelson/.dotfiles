return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
  config = function()
    -- local noirbuddy_lualine = require('noirbuddy.plugins.lualine')
    -- local colors = require('noirbuddy.colors').all()
    -- local theme = noirbuddy_lualine.theme
    -- local sections = noirbuddy_lualine.sections
    -- local inactive_sections = noirbuddy_lualine.inactive_sections
    --
    -- theme.normal.c.bg = colors.noir_9

    require('lualine').setup({
      options = {
        icons_enabled = true,
        filetype = { colored = false},
        theme = 'catppuccin',
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
        -- component_separators = '|',
        -- section_separators = '',
        globalstatus = true,
        -- sections = sections,
        -- inactive_sections = inactive_sections,
        disabled_filetypes = {
          statusline = {
            'TelescopePrompt',
          },
        },
      },
    })
  end,
}
