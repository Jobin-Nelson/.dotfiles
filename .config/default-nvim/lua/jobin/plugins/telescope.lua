return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'xiyaowong/telescope-emoji.nvim',
    },
    config = function()
      local actions = require('telescope.actions')
      local my_actions = require('jobin.config.custom.my_actions')
      require('telescope').setup({
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['d'] = 'delete_buffer',
              },
            }
          }
        },
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = actions.cycle_previewers_next,
              ["<C-a>"] = actions.cycle_previewers_prev,
              ["<A-y>"] = my_actions.copy_entry,
            },
          },
          git_worktrees = vim.g.git_worktrees,
          prompt_prefix = "❯ ",
          selection_caret = "❯ ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        }
      })
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('emoji')
    end
  },
}
