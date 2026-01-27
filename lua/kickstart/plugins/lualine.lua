-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#2E3440',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.grey },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = colors.grey },
  },
  insert = { a = { fg = colors.black, bg = colors.violet } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },
  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional for icons
    config = function()
      require('lualine').setup {
        options = {
          theme = bubbles_theme,
          icons_enabled = true,
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          statusline = {},
          winbar = {},
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'buffers',
              show_filename_only = true, -- Show only file names
              mode = 2, -- Show buffer name + number
              symbols = {
                modified = '[+]', -- Indicator for modified buffers
                alternate_file = '', -- Disable alternate file prefix
                directory = '', -- Icon for directories
              },
              buffers_color = {
                active = { fg = colors.violet, bg = colors.grey, gui = 'bold' }, -- Added bg for active buffer
                inactive = { fg = colors.white, bg = colors.grey }, -- Added bg for inactive buffers
              },
            },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        -- tabline = {
        --   lualine_a = {}, -- Buffer list should remain in tabline
        --   lualine_b = {},
        --   lualine_c = {},
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = {},
        -- },
        -- extensions = { 'fugitive' },
      }
    end,
  },
}
