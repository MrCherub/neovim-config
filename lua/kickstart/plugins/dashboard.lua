return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local db = require 'dashboard'
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
      pattern = 'DashboardReady',
      callback = function()
        -- General
        vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#ffffff', bg = '#44475a' }) -- Header color
        vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#ff79c6', bg = '#282a36' }) -- Footer color

        -- Hyper theme
        vim.api.nvim_set_hl(0, 'DashboardProjectTitle', { fg = '#50fa7b' }) -- Project title
        vim.api.nvim_set_hl(0, 'DashboardProjectTitleIcon', { fg = '#8be9fd' }) -- Project title icon
        vim.api.nvim_set_hl(0, 'DashboardProjectIcon', { fg = '#f1fa8c' }) -- Project icon
        vim.api.nvim_set_hl(0, 'DashboardMruTitle', { fg = '#ffb86c' }) -- MRU title
        vim.api.nvim_set_hl(0, 'DashboardMruIcon', { fg = '#ff5555' }) -- MRU icon
        vim.api.nvim_set_hl(0, 'DashboardFiles', { fg = '#bd93f9' }) -- Files list
        vim.api.nvim_set_hl(0, 'DashboardShortCutIcon', { fg = '#6272a4' }) -- Shortcut icon

        -- Doom theme
        vim.api.nvim_set_hl(0, 'DashboardDesc', { fg = '#f8f8f2' }) -- Description text
        vim.api.nvim_set_hl(0, 'DashboardKeyHighlight', { fg = '#ffffff' }) -- Key highlight
        vim.api.nvim_set_hl(0, 'DashboardIcon', { fg = '#ff79c6' }) -- Icon highlight
        vim.api.nvim_set_hl(0, 'DashboardShortCut', { fg = '#8be9fd' }) -- Shortcut text
      end, -- Apply custom highlights after the theme is loaded
    })
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
