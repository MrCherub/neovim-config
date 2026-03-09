local M = {}

local uv = vim.uv

local state = {
  ttl_ms = 5000,
  cache = {},
  group = nil,
}

local function now_ms()
  return uv.now()
end

local function refresh_winbar()
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.refresh { place = { 'winbar' } }
  end
end

local function parse_status(stdout)
  local branch = nil
  local changed = 0

  for line in stdout:gmatch '[^\r\n]+' do
    if vim.startswith(line, '## ') then
      branch = line:gsub('^## ', ''):gsub('%.%.+.*$', '')
    elseif line ~= '' then
      changed = changed + 1
    end
  end

  return branch, changed
end

local function resolve_cwd(winid)
  if winid and winid ~= 0 and vim.api.nvim_win_is_valid(winid) then
    return vim.api.nvim_win_call(winid, function()
      return vim.fn.getcwd()
    end)
  end

  return vim.fn.getcwd()
end

function M.refresh(cwd)
  if not cwd or cwd == '' then
    return
  end

  local entry = state.cache[cwd] or {}
  if entry.refreshing then
    return
  end

  entry.refreshing = true
  state.cache[cwd] = entry

  vim.system({ 'git', '-C', cwd, 'status', '--porcelain=1', '--branch' }, { text = true }, function(result)
    local branch = nil
    local changed = nil
    if result.code == 0 and result.stdout then
      branch, changed = parse_status(result.stdout)
    end

    vim.schedule(function()
      local current = state.cache[cwd] or {}
      current.refreshing = false
      current.last_update_ms = now_ms()
      current.branch = branch
      current.changed = changed
      current.valid = branch ~= nil or changed ~= nil
      state.cache[cwd] = current
      refresh_winbar()
    end)
  end)
end

function M.get(winid)
  local cwd = resolve_cwd(winid)
  if not cwd or cwd == '' then
    return nil, nil
  end

  local entry = state.cache[cwd]
  if not entry or ((now_ms() - (entry.last_update_ms or 0)) > state.ttl_ms and not entry.refreshing) then
    M.refresh(cwd)
  end

  entry = state.cache[cwd]
  if not entry or not entry.valid then
    return nil, nil
  end

  return entry.branch, entry.changed
end

function M.setup(opts)
  if state.group then
    return M
  end

  state.ttl_ms = (opts and opts.ttl_ms) or state.ttl_ms
  state.group = vim.api.nvim_create_augroup('kickstart-git-status', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged', 'FocusGained', 'VimEnter' }, {
    group = state.group,
    callback = function(args)
      local winid = 0
      if args.event == 'BufEnter' or args.event == 'FocusGained' then
        winid = vim.api.nvim_get_current_win()
      end
      M.refresh(resolve_cwd(winid))
    end,
  })

  M.refresh(resolve_cwd(0))
  return M
end

return M
