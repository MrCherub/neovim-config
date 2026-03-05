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
      local wave_colors = {
        '#6d8fe8',
        '#7aa2f7',
        '#9bb5ff',
        '#c4d2ff',
        '#ffffff',
        '#efe7ff',
        '#d9c2ff',
        '#c4b5fd',
        '#b7a3ff',
      }
      local wave_hl_prefix = 'LualineWaveName'
      local wave_phase = 0

      for idx, color in ipairs(wave_colors) do
        vim.api.nvim_set_hl(0, wave_hl_prefix .. idx, { fg = color, bg = colors.grey, bold = true })
      end

      local function wave_name_text(name)
        local out = {}
        local chars = vim.fn.strchars(name)
        for ci = 0, chars - 1 do
          local b1 = vim.str_byteindex(name, ci)
          local b2 = vim.str_byteindex(name, ci + 1)
          local ch = name:sub(b1 + 1, b2)
          if ch == '%' then
            ch = '%%'
          end
          local hl_idx = ((ci + wave_phase) % #wave_colors) + 1
          out[#out + 1] = ('%%#%s%d#%s'):format(wave_hl_prefix, hl_idx, ch)
        end
        out[#out + 1] = '%*'
        return table.concat(out)
      end

      local wave_timer = vim.uv.new_timer()
      wave_timer:start(
        0,
        130,
        vim.schedule_wrap(function()
          local mode = vim.api.nvim_get_mode().mode
          if mode:sub(1, 1) == 'n' then
            wave_phase = wave_phase + 1
          end
          local ok, lualine = pcall(require, 'lualine')
          if ok then
            lualine.refresh { place = { 'statusline' } }
          end
          vim.cmd 'redrawstatus'
        end)
      )

      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          if wave_timer then
            wave_timer:stop()
            wave_timer:close()
            wave_timer = nil
          end
        end,
      })

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
              show_filename_only = true,
              mode = 2, -- buffer name + index
              padding = { left = 1, right = 0 },
              component_separators = { left = ' ', right = ' ' },
              section_separators = { left = ' ', right = ' ' },
              max_length = function()
                -- Animated highlight markup increases computed string length.
                -- Give buffers extra room so non-active items don't get trimmed out.
                return math.max(vim.o.columns * 10, 1000)
              end,
              fmt = function(name, buf)
                local is_normal_mode = vim.api.nvim_get_mode().mode:sub(1, 1) == 'n'
                if is_normal_mode and buf and buf.is_current and buf:is_current() then
                  return wave_name_text(name)
                end
                return name
              end,
              symbols = {
                modified = '[+]',
                alternate_file = '',
                directory = '',
              },
              buffers_color = {
                active = { fg = colors.violet, bg = colors.grey, gui = 'bold' },
                inactive = { fg = colors.white, bg = colors.grey },
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
