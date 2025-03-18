return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap', -- Ensure nvim-dap is included
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },

      {
        '<F10>',
        function()
          dap.terminate() -- terminate first
          vim.defer_fn(function()
            dap.continue()
          end, 100) -- restart after 100ms delay
        end,
        desc = 'Debug: Restart',
      },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'debugpy',
        'java-debug-adapter',
      },
    }

    dapui.setup {
      -- Set icons for expanded/collapsed and current frame
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },

      -- Add the missing required fields
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },

      -- Element specific settings
      element_mappings = {},

      -- Automatically expand lines that contain breakpoints, current frame, etc.
      expand_lines = true,

      -- Force buffers to stay open (useful for preserving their layout)
      force_buffers = true,

      -- Define layouts for the UI
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40, -- Height of the window
          position = 'left', -- Can be 'left', 'right', 'top', 'bottom'
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10, -- Height of the window
          position = 'bottom', -- Can be 'left', 'right', 'top', 'bottom'
        },
      },

      -- Floating windows settings
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floating window width
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
          debug,
        },
      },

      -- Render settings
      render = {
        indent = 2, -- Default indentation level
        line_separator = '⮞', -- Symbol to separate lines
        current_frame = true, -- Highlight the current frame
        -- Add any other required fields here based on the DAP UI documentation
        max_type_length = nil, -- Can limit the length of variable types
      },

      -- Optional settings for controls
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Additional DAP configurations for Go
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Add listeners to open/close dapui automatically
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
