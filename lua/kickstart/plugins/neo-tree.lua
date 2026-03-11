-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '\\',
      function()
        local reveal_file = vim.fn.expand '%:p'
        if reveal_file == '' then
          reveal_file = vim.fn.getcwd()
        else
          local stat = vim.uv.fs_stat(reveal_file)
          if not stat then
            reveal_file = vim.fn.getcwd()
          end
        end

        require('neo-tree.command').execute {
          action = 'focus',
          source = 'filesystem',
          position = 'left',
          reveal_file = reveal_file,
          reveal_force_cwd = true,
        }
      end,
      desc = 'NeoTree reveal current file or cwd',
      silent = true,
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
