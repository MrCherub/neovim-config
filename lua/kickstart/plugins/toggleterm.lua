-- ~/.config/nvim/lua/kickstart/plugins/toggleterm.lua

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 20,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        width = 130,
        height = 45,
        winblend = 3,
      },
    }

    -- Map <Space> + f + t to open the floating terminal
    vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = true })
  end,
}
