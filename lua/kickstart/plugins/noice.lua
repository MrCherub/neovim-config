-- Return a table containing the plugin configuration
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify', -- optional if you want notification support
    },
    config = function() -- Place the config function here
      require('noice').setup {
        lsp = {
          -- override markdown rendering for compatibility with cmp and Treesitter
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
          progress = {
            enabled = true, -- Enable LSP progress messages
            position = 'center', -- Set the position to center
          },
        },
        -- Presets for easier configuration
        presets = {
          bottom_search = false, -- Disable bottom search
          command_palette = false, -- Disable command palette
          long_message_to_split = false, -- Disable long messages to split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
      vim.keymap.set('n', '<leader>zz', '<cmd>NoiceDismiss<CR>', { desc = 'Dismiss Noice Message' })
    end,
  },
}
