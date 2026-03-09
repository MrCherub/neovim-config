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
      local file_time = require 'kickstart.file_time'
      local git_status = require 'kickstart.git_status'

      local function noice_recording_component()
        local ok, noice = pcall(require, 'noice')
        if not ok or not noice.api or not noice.api.status or not noice.api.status.mode then
          return ''
        end
        if not noice.api.status.mode.has() then
          return ''
        end
        return noice.api.status.mode.get()
      end

      file_time.setup()
      git_status.setup()

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
      local wave_idle_hl = 'LualineWaveIdle'
      local wave_phase = 0
      local wave_visible = true
      local wave_tick = 0
      local wave_interval_ms = 340
      local wave_toggle_ticks = 4

      for idx, color in ipairs(wave_colors) do
        vim.api.nvim_set_hl(0, wave_hl_prefix .. idx, { fg = color, bg = colors.grey, bold = true })
      end
      vim.api.nvim_set_hl(0, wave_idle_hl, { fg = colors.violet, bg = colors.grey, bold = true })

      local function wave_name_text(name, animate)
        local out = {}
        local chars = vim.fn.strchars(name)
        for ci = 0, chars - 1 do
          local b1 = vim.str_byteindex(name, ci)
          local b2 = vim.str_byteindex(name, ci + 1)
          local ch = name:sub(b1 + 1, b2)
          if ch == '%' then
            ch = '%%'
          end
          if animate then
            local hl_idx = ((ci + wave_phase) % #wave_colors) + 1
            out[#out + 1] = ('%%#%s%d#%s'):format(wave_hl_prefix, hl_idx, ch)
          else
            out[#out + 1] = ('%%#%s#%s'):format(wave_idle_hl, ch)
          end
        end
        out[#out + 1] = '%*'
        return table.concat(out)
      end

      local wave_timer = vim.uv.new_timer()
      wave_timer:start(
        0,
        wave_interval_ms,
        vim.schedule_wrap(function()
          local mode = vim.api.nvim_get_mode().mode
          if mode:sub(1, 1) == 'n' then
            wave_tick = wave_tick + 1
            if wave_visible then
              wave_phase = wave_phase + 1
            end
            if wave_tick % wave_toggle_ticks == 0 then
              wave_visible = not wave_visible
            end
          else
            wave_visible = true
            wave_tick = 0
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
          file_time.stop()
          if wave_timer then
            wave_timer:stop()
            wave_timer:close()
            wave_timer = nil
          end
        end,
      })

      vim.api.nvim_set_hl(0, 'LualineFileTime', { fg = colors.black, bg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, 'LualineGitBranch', { fg = colors.black, bg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, 'LualineGitDirty', { fg = colors.black, bg = '#a6e3a1', bold = true })
      vim.api.nvim_set_hl(0, 'LualineGitClean', { fg = colors.black, bg = colors.cyan, bold = true })

      local function file_time_component()
        local winid = tonumber(vim.g.statusline_winid) or 0
        local bufnr = winid ~= 0 and vim.api.nvim_win_get_buf(winid) or vim.api.nvim_get_current_buf()
        return file_time.get_display(bufnr)
      end

      local function git_branch_component()
        local winid = tonumber(vim.g.statusline_winid) or 0
        local branch = git_status.get(winid)
        if not branch or branch == '' then
          return ''
        end
        return (' %s'):format(branch)
      end

      local function git_dirty_component()
        local winid = tonumber(vim.g.statusline_winid) or 0
        local _, changed = git_status.get(winid)
        if changed == nil then
          return ''
        end
        if changed > 0 then
          return (' %d'):format(changed)
        end
        return '󰄬 clean'
      end

      require('lualine').setup {
        options = {
          theme = bubbles_theme,
          icons_enabled = true,
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            winbar = {
              'dashboard',
              'TelescopePrompt',
              'neo-tree',
              'lazy',
              'mason',
              'help',
              'qf',
            },
          },
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
                  return wave_name_text(name, wave_visible)
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
          lualine_x = {
            {
              noice_recording_component,
              color = { fg = colors.red, bg = colors.grey, gui = 'bold' },
            },
            'encoding',
            'fileformat',
            'filetype',
          },
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
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              git_branch_component,
              separator = { left = '', right = '' },
              color = 'LualineGitBranch',
              padding = { left = 0, right = 0 },
            },
            {
              git_dirty_component,
              separator = { left = '', right = '' },
              color = function()
                local winid = tonumber(vim.g.statusline_winid) or 0
                local _, changed = git_status.get(winid)
                if changed and changed > 0 then
                  return 'LualineGitDirty'
                end
                return 'LualineGitClean'
              end,
              padding = { left = 0, right = 0 },
            },
            {
              file_time_component,
              separator = { left = '', right = '' },
              color = 'LualineFileTime',
              padding = { left = 0, right = 0 },
            },
          },
        },
        inactive_winbar = {},
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
