local M = {}

local ns = vim.api.nvim_create_namespace 'kickstart-function-line-count'
local timers = {}
local enabled = true

local config = {
  debounce_ms = 300,
  excluded_buftypes = {
    help = true,
    nofile = true,
    prompt = true,
    quickfix = true,
    terminal = true,
  },
  excluded_filetypes = {
    ['neo-tree'] = true,
    Trouble = true,
    alpha = true,
    checkhealth = true,
    dashboard = true,
    lazy = true,
    mason = true,
    minifiles = true,
    noice = true,
    qf = true,
  },
  highlight = 'FunctionLineCount',
  large_file_line_limit = 5000,
  min_lines = 2,
}

local exact_node_types = {
  arrow_function = true,
  class_function_definition = true,
  func_declaration = true,
  func_literal = true,
  function_declaration = true,
  function_definition = true,
  function_item = true,
  function_statement = true,
  lexical_declaration = false,
  local_function = true,
  method_declaration = true,
  method_definition = true,
}

local blocked_fragments = {
  argument = true,
  arguments = true,
  call = true,
  declarator = true,
  parameter = true,
  parameters = true,
  signature = true,
  type = true,
}

local function clear_buffer(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end
end

local function should_skip(bufnr)
  if not enabled or not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return true
  end

  local bo = vim.bo[bufnr]
  if config.excluded_buftypes[bo.buftype] or config.excluded_filetypes[bo.filetype] then
    return true
  end

  if not bo.modifiable or not bo.buflisted then
    return true
  end

  if vim.api.nvim_buf_line_count(bufnr) > config.large_file_line_limit then
    return true
  end

  return false
end

local function is_function_node(node)
  local node_type = node:type()
  if exact_node_types[node_type] then
    return true
  end

  if exact_node_types[node_type] == false then
    return false
  end

  if not (node_type:find('function', 1, true) or node_type:find('method', 1, true) or node_type:find('func', 1, true)) then
    return false
  end

  for fragment in pairs(blocked_fragments) do
    if node_type:find(fragment, 1, true) then
      return false
    end
  end

  return true
end

local function collect_functions(node, counts)
  if is_function_node(node) then
    local start_row, _, end_row, _ = node:range()
    local line_count = end_row - start_row + 1
    if line_count >= config.min_lines then
      local previous = counts[start_row]
      if not previous or line_count > previous.line_count then
        counts[start_row] = { line_count = line_count }
      end
    end
  end

  for child in node:iter_children() do
    if child:named() then
      collect_functions(child, counts)
    end
  end
end

local function render(bufnr)
  if should_skip(bufnr) then
    clear_buffer(bufnr)
    return
  end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    clear_buffer(bufnr)
    return
  end

  local parsed_ok, trees = pcall(parser.parse, parser)
  if not parsed_ok or not trees or not trees[1] then
    clear_buffer(bufnr)
    return
  end

  local root = trees[1]:root()
  local counts = {}
  collect_functions(root, counts)

  clear_buffer(bufnr)

  for line, data in pairs(counts) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
      virt_text = { { ('%dL'):format(data.line_count), config.highlight } },
      virt_text_pos = 'eol_right_align',
      hl_mode = 'combine',
      priority = 90,
    })
  end
end

local function schedule_render(bufnr)
  if should_skip(bufnr) then
    clear_buffer(bufnr)
    return
  end

  local timer = timers[bufnr]
  if not timer then
    timer = vim.uv.new_timer()
    timers[bufnr] = timer
  else
    timer:stop()
  end

  timer:start(
    config.debounce_ms,
    0,
    vim.schedule_wrap(function()
      if timer and not timer:is_closing() then
        timer:stop()
      end
      render(bufnr)
    end)
  )
end

local function stop_timer(bufnr)
  local timer = timers[bufnr]
  if not timer then
    return
  end
  timer:stop()
  timer:close()
  timers[bufnr] = nil
end

function M.toggle()
  enabled = not enabled

  if enabled then
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      schedule_render(bufnr)
    end
  else
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      clear_buffer(bufnr)
    end
  end

  vim.notify(('Function line counts %s'):format(enabled and 'enabled' or 'disabled'))
end

function M.refresh(bufnr)
  schedule_render(bufnr or vim.api.nvim_get_current_buf())
end

function M.setup()
  vim.api.nvim_set_hl(0, config.highlight, { link = 'Comment', default = true })

  local group = vim.api.nvim_create_augroup('kickstart-function-line-count', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufWritePost', 'InsertLeave', 'TextChanged', 'TextChangedI', 'WinResized' }, {
    group = group,
    callback = function(args)
      schedule_render(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args)
      clear_buffer(args.buf)
      stop_timer(args.buf)
    end,
  })

  vim.api.nvim_create_user_command('FunctionLineCountToggle', function()
    M.toggle()
  end, { desc = 'Toggle function line counts' })
end

return M
