return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local db = require 'dashboard'
    local wave_ns = vim.api.nvim_create_namespace 'dashboard_wave'
    local wave_buf = nil
    local wave_phase = 0
    local wave_token = 0

    local wave_colors = {
      '#00e5ff',
      '#38bdf8',
      '#22d3ee',
      '#00d4aa',
      '#7afcff',
    }

    local function stop_dashboard_wave()
      wave_token = wave_token + 1
      if wave_buf and vim.api.nvim_buf_is_valid(wave_buf) then
        vim.api.nvim_buf_clear_namespace(wave_buf, wave_ns, 0, -1)
      end
      wave_buf = nil
    end

    local function paint_dashboard_wave(buf)
      if not vim.api.nvim_buf_is_valid(buf) then
        stop_dashboard_wave()
        return
      end

      vim.api.nvim_buf_clear_namespace(buf, wave_ns, 0, -1)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local max_lines = math.min(#lines, 45)
      local found_art = false

      for lnum = 1, max_lines do
        local line = lines[lnum]
        if line:find '%S' then
          found_art = true
        elseif found_art and lnum > 12 then
          break
        end

        if line:find '%S' then
          local char_count = vim.fn.strchars(line)
          for ci = 0, char_count - 1 do
            local start_col = vim.str_byteindex(line, ci)
            local end_col = vim.str_byteindex(line, ci + 1)
            local ch = line:sub(start_col + 1, end_col)
            local codepoint = vim.fn.char2nr(ch)

            -- Only animate active braille dots from the art.
            -- U+2800 is blank braille and should stay untouched.
            if codepoint >= 0x2801 and codepoint <= 0x28FF then
              local hl_idx = ((ci + lnum + wave_phase) % #wave_colors) + 1
              vim.api.nvim_buf_add_highlight(buf, wave_ns, 'DashboardWave' .. hl_idx, lnum - 1, start_col, end_col)
            end
          end
        end
      end

      wave_phase = wave_phase + 1
    end

    local function tick_dashboard_wave(token)
      vim.defer_fn(function()
        if token ~= wave_token or not wave_buf or not vim.api.nvim_buf_is_valid(wave_buf) then
          return
        end
        if vim.bo[wave_buf].filetype ~= 'dashboard' then
          stop_dashboard_wave()
          return
        end
        paint_dashboard_wave(wave_buf)
        tick_dashboard_wave(token)
      end, 100)
    end

    local function start_dashboard_wave(buf)
      stop_dashboard_wave()
      wave_buf = buf
      wave_phase = 0
      wave_token = wave_token + 1
      local token = wave_token
      paint_dashboard_wave(buf)
      tick_dashboard_wave(token)
    end

    db.setup {
      theme = 'doom',
      config = {
        header = {
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠀⠀⠀⠀⠀⡀⠠⠸⠀⠰⠀⢠⠤⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠀⢀⠄⠆⠁⠀⠀⡀⠆⢠⠀⠘⠀⠀⠀⠈⠆⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠔⠁⠀⠀⠀⠀⠀⠈⠲⣼⠀⠀⠀⠀⠀⠀⠀⠈⠓⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠠⡀⠀⠀⠀⢀⠂⠠⣶⣄⡀⢺⣶⣶⣶⠀⠀⠀⠀⠀⠀⠈⠂⠀⠀⠀⠀⠀⠀',
          '⠠⡐⢀⠀⠀⢀⡍⠀⠞⠛⠛⠻⠟⠛⢿⣿⡟⠀⠀⢠⠀⠄⠀⠀⢁⠀⠀⠀⠀⠀',
          '⠆⠃⠘⠀⠀⢀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠹⣿⠆⢀⠀⡄⢸⡀⠀⠀⠀⠀⠀⠀⠀',
          '⠐⠰⡆⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡀⢸⠀⠃⠀⠁⠀⠀⠀⠀⠀⠀⠀',
          '⠀⡀⡇⠀⢸⡆⣈⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣡⢸⣧⢀⠀⡆⠀⠀⠀⠀⠀⠀⠀',
          '⣆⢳⣷⡇⢸⣇⣷⣾⣝⣦⠀⠀⠀⠀⠀⢴⣫⣿⣼⣿⣸⠀⡇⠀⢰⠀⠀⠀⠀⠀',
          '⢡⠀⣇⡇⠸⡏⢷⡺⢟⢟⠃⠀⠀⠀⠀⠿⣶⠟⣿⣿⡿⠀⠀⠰⡎⠀⠀⠀⠀⠀',
          '⠈⢆⣿⣿⢸⠈⠑⠛⠓⠀⠀⠀⠀⠀⠀⠈⠘⠛⠓⢻⣷⢠⡄⣄⠇⠀⠀⠀⠀⠀',
          '⠀⢐⣿⣾⢸⡆⠀⠀⠀⠀ ⠀⠙⠀⠀⠀  ⠀⢸⣿⢸⢧⡝⠀⠀⠀⠀ ⠀',
          '⠀⠉⣻⣿⣼⡷⣀⣀⠀⠀⠈⠉⠉⠉⠉⠀⠀⣀⠠⠊⢈⣿⡜⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⣿⢿⠋⠐⢋⣤⢴⣷⣶⣦⠠⢴⣶⣿⣄⡀⠀⠀⠀⡗⠁⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠙⠀⠀⢠⣾⣿⣿⣯⣗⣽⣷⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠙⡄⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠈⣋⡁⠀⠐⠀⠀⠀⠀⠀⠀⠀',
          '⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⡧⣠⣤⣷⣶⣿⣿⣧⠀⠀',
          '⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀',
          '⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀',
          '⠀⠀⠀⠿⠿⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧',
          '⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡉⠉⣿⣿⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋',
          '⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⡏⠁⠀⠹⣿⣿⣿⠋⣿⣿⣿⣿⡿⠿⠋⠉⠀⠀⠀⠀',
          '⠀⠀⠀⠀⠀⠈⠛⠛⠋⠁⠀⠀⠀⠀⢿⣿⡿⠀⠘⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          -- '',
          -- '',
          -- '',
          -- '',
          -- '',
          -- '',
          -- '',
          -- '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠚⣷⠀⠀⣀⣤⠀⠀⠀⠀⠀⠀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⣟⢀⡴⠋⠀⠀⣿⠖⠋⢀⡏⠀⠀⠀⡀⡀⠀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⢀⡀⡼⠀⢸⡟⡸⠀⠀⠀⠃⠀⠀⢸⡧⠜⠛⠛⣻⠃⠀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⢺⢾⡃⠀⠈⣴⠁⢻⡀⠀⠀⢀⡠⠀⠀⠀⠀⢸⣇⣤⡀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⠸⡜⠂⠀⠀⣟⠀⢸⠑⠀⠰⠁⠀⠀⠀⠀⠀⠛⠉⡼⠁⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⠈⣷⣾⣿⣿⣿⣿⣾⣶⣶⣤⣀⡀⢰⠕⠋⠀⠀⠸⠧⣤⡄',
          -- '⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣔⠈⣤⣶⡚⠁⠀',
          -- '⠀⠀⠀⣠⣶⡀⢸⡟⠿⡿⠿⡟⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⠋⠁⠀⠀⠀',
          -- '⠀⠀⠀⢰⢧⡷⡿⢘⡎⠀⠀⠐⣶⢶⣲⠈⠙⠋⠉⠉⠉⠁⡘⡯⣿⡶⣆⡀⠀',
          -- '⠀⠀⠀⢾⢈⣼⣿⣤⣿⣶⣶⣶⣿⣿⣧⣤⣄⣀⣀⣀⣤⣾⣿⣿⢯⢇⣿⢳⠀',
          -- '⠀⠀⠀⠈⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⣷⣬⠏⠀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⠉⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠻⠟⠋⠁⠀⠀⠀⠀',
          -- '⠀⠀⠀⠀⢀⣀⣀⡀⣰⣿⣿⣿⣿⣿⣿⣿⡿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          -- '⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          -- '⠀⠀⠀⠀⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
          -- '⢀⣤⣶⣴⣿⣿⣿⡧⠀⠉⠙⢿⣿⣿⣿⣿⣾⣶⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀',
          -- '⠀⠉⠛⠛⠿⣿⣿⡇⠀⠀⠀⠀⠻⣿⣿⣿⡿⠿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀',
          -- '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠸⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀',
          -- '',
          -- '',
          -- '',
        },
        center = {
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find File           ',
            desc_hl = 'DashboardWhiteText',
            key = 'f',
            keymap = 'SPC s ',
            key_hl = 'DashboardKeyHighlight',
            key_format = ' %s', -- remove default surrounding `[]`
            -- action = 'lua print(2)', -- action when pressed
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find Dotfiles',
            desc_hl = 'DashboardWhiteText',
            key = 'n',
            keymap = 'SPC s ',
            key_hl = 'DashboardKeyHighlight',
            key_format = ' %s', -- remove default surrounding `[]`
            -- action = 'lua print(3)', -- action when pressed
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Recent',
            desc_hl = 'DashboardWhiteText',
            key = '.',
            keymap = 'SPC s ',
            key_hl = 'DashboardKeyHighlight',
            key_format = ' %s', -- remove default surrounding `[]`
          },
          -- {
          --   icon = ' ', -- Terminal icon
          --   icon_hl = 'Title', -- Highlight group for the icon
          --   desc = 'Terminal', -- Description for the action
          --   desc_hl = 'DashboardWhiteText', -- Highlight for the description
          --   key = 't', -- Key for the action
          --   keymap = 'SPC f ', -- Key mapping for the action
          --   key_hl = 'DashboardKeyHighlight', -- Highlight for the key
          --   key_format = ' %s', -- Format for the key
          -- },
        },
        footer = { '' }, -- your footer
        header_pad = 0, -- Add padding above the header
        center_pad = 0, -- Add padding above the center content
        footer_pad = 0, -- Add padding above the footer
      },
    }
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'DashboardReady', 'DashboardLoaded' },
      callback = function()
        for idx, color in ipairs(wave_colors) do
          vim.api.nvim_set_hl(0, 'DashboardWave' .. idx, { fg = color })
        end

        -- General
        vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#ffffff', bg = 'NONE' }) -- Header color
        vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#ff79c6', bg = 'NONE' }) -- Footer color

        -- Hyper theme
        vim.api.nvim_set_hl(0, 'DashboardProjectTitle', { fg = '#50fa7b' }) -- Project title
        vim.api.nvim_set_hl(0, 'DashboardProjectTitleIcon', { fg = '#8be9fd' }) -- Project title icon
        vim.api.nvim_set_hl(0, 'DashboardProjectIcon', { fg = '#f1fa8c' }) -- Project icon
        vim.api.nvim_set_hl(0, 'DashboardMruTitle', { fg = '#ffb86c' }) -- MRU title
        vim.api.nvim_set_hl(0, 'DashboardMruIcon', { fg = '#ff5555' }) -- MRU icon
        vim.api.nvim_set_hl(0, 'DashboardFiles', { fg = '#bd93f9' }) -- Files list
        vim.api.nvim_set_hl(0, 'DashboardShortCutIcon', { fg = '#6272a4' }) -- Shortcut icon

        -- Doom theme
        vim.api.nvim_set_hl(0, 'DashboardDesc', { fg = '#f8f8f2', bg = 'NONE' }) -- Description text
        vim.api.nvim_set_hl(0, 'DashboardKeyHighlight', { fg = '#ffffff' }) -- Key highlight
        vim.api.nvim_set_hl(0, 'DashboardIcon', { fg = '#ff79c6', bg = 'NONE' }) -- Icon highlight
        vim.api.nvim_set_hl(0, 'DashboardShortCut', { fg = '#8be9fd', bg = 'NONE' }) -- Shortcut text

        local buf = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'dashboard' then
          start_dashboard_wave(buf)
        end
      end, -- Apply custom highlights after the theme is loaded
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dashboard',
      callback = function(ev)
        start_dashboard_wave(ev.buf)
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWipeout', 'VimLeavePre' }, {
      callback = function(ev)
        if wave_buf and ev.buf == wave_buf then
          stop_dashboard_wave()
        end
      end,
    })

    vim.api.nvim_create_user_command('DashboardWaveRestart', function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.bo[buf].filetype == 'dashboard' then
        start_dashboard_wave(buf)
      end
    end, {})
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
