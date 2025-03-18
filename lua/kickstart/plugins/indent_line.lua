return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      exclude = {
        filetypes = { 'dashboard', 'lspinfo', 'packer', 'help' }, -- Exclude specific filetypes
      },
    },
  },
}
