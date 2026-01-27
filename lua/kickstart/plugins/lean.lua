return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('lean').setup {
      lsp = {
        on_attach = require('kickstart.plugins.lsp').on_attach, -- or your own on_attach
      },
      mappings = true,
      abbreviations = true,
      lsp3 = { enable = true },
      lsp4 = { enable = true },
    }
  end,
}
