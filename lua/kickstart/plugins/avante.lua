return {
  'yetone/avante.nvim', -- GitHub repo for Avante
  event = 'VeryLazy',
  lazy = false,
  version = false, -- Set to "*" for latest release, or false for the latest code changes
  opts = {
    provider = 'openai',
    openai = {
      endpoint = 'https://api.openai.com/v1',
      model = 'gpt-4o', -- your desired model
      timeout = 30000, -- timeout in milliseconds
      temperature = 0, -- adjust if needed
      max_tokens = 4096,
      -- reasoning_effort = "high"  -- optional for reasoning models
    },
  },
  build = 'make', -- Command to build the plugin from source
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    -- Optional dependencies
    'echasnovski/mini.pick',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true, -- required for Windows users
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
