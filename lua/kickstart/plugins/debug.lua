return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F10>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F11>', dap.step_into, desc = 'Debug: Step Into' },
      { '<S-F11>', dap.step_out, desc = 'Debug: Step Out' },
      {
        '<leader>dr',
        function()
          dap.restart()
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
      {
        '<leader>jm',
        function()
          local main_class = vim.fn.input 'Main class: '
          if main_class ~= '' then
            require('dap').configurations.java[1].mainClass = main_class
            print('Set Java main class to: ' .. main_class)
          else
            print 'No main class set; using default.'
          end
        end,
        desc = 'Debug: Set Java Main Class',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: Toggle DAP UI' },
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Enable debug logging by default
    dap.set_log_level 'DEBUG'

    -- Increase DAP timeout to handle slow adapters
    dap.defaults.fallback.timeout = 30000 -- 30 seconds

    -- Setup mason-nvim-dap with default handlers for automatic configuration
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve',
        'debugpy',
        'java-debug-adapter',
        'cpptools',
        'js-debug-adapter',
      },
      -- Use default handlers to automatically configure DAP adapters
      handlers = {
        function(config)
          -- Default handler for all adapters
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    }

    -- DAP UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = 'rounded',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      render = {
        indent = 2,
        line_separator = '⮞',
        current_frame = true,
        max_type_length = nil,
      },
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

    -- Go DAP configuration
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Lua DAP configuration (using debugpy-like adapter via Mason)
    -- Install via Mason: lua-debugpy
    local lua_path = vim.fn.exepath 'lua' or '/opt/homebrew/bin/lua'
    if vim.fn.executable 'lua-language-server' == 1 then
      dap.adapters.lua = {
        type = 'executable',
        command = 'lua-language-server',
        args = { '--stdio' },
      }
      dap.configurations.lua = {
        {
          type = 'lua',
          request = 'launch',
          name = 'Launch Lua',
          program = function()
            return lua_path
          end,
          args = { '${file}' },
          cwd = '${workspaceFolder}',
        },
      }
    end

    -- Python DAP configuration
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          local venv = vim.fn.getenv 'VIRTUAL_ENV'
          if venv and venv ~= '' then
            return venv .. '/bin/python3'
          end
          return vim.fn.exepath 'python3' or 'python3'
        end,
      },
    }

    -- Java DAP configuration
    dap.adapters.java = {
      type = 'executable',
      command = vim.fn.exepath 'java',
      args = { '-jar', vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/java-debug-adapter.jar') },
    }
    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch Java',
        program = '${file}',
        mainClass = '', -- Default empty to avoid prompt at startup
        javaExec = vim.fn.exepath 'java',
      },
    }

    -- C++ DAP configuration
    dap.adapters.cpp = {
      type = 'executable',
      command = 'cpptools',
      args = {},
    }
    dap.configurations.cpp = {
      {
        type = 'cpp',
        request = 'launch',
        name = 'Launch C++',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        args = {},
      },
    }

    -- JavaScript DAP configuration
    dap.adapters.javascript = {
      type = 'executable',
      command = '/opt/homebrew/bin/node',
      args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/out/src/jsDebugAdapter.js' },
    }
    dap.configurations.javascript = {
      {
        type = 'javascript',
        request = 'launch',
        name = 'Launch JavaScript',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = '/opt/homebrew/bin/node',
      },
    }

    -- DAP UI listeners
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
