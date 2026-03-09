local M = {}

local uv = vim.uv

local defaults = {
  tick_ms = 1000,
  idle_threshold_ms = 45000,
}

local state = {
  totals = {},
  active = {
    bufnr = nil,
    last_tick_ms = nil,
    last_activity_ms = nil,
  },
  timer = nil,
  opts = vim.deepcopy(defaults),
}

local function now_ms()
  return uv.now()
end

local function is_trackable_buffer(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if vim.bo[bufnr].buftype ~= '' then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr) ~= ''
end

local function current_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  if not is_trackable_buffer(bufnr) then
    return nil
  end

  return bufnr
end

local function add_time(bufnr, delta_ms)
  if not bufnr or delta_ms <= 0 then
    return
  end

  state.totals[bufnr] = (state.totals[bufnr] or 0) + (delta_ms / 1000)
end

local function flush_active(now)
  local active = state.active
  if not active.bufnr or not active.last_tick_ms then
    return
  end

  if not is_trackable_buffer(active.bufnr) then
    state.totals[active.bufnr] = nil
    active.bufnr = nil
    active.last_tick_ms = nil
    active.last_activity_ms = nil
    return
  end

  local cutoff_ms = math.min(now, active.last_activity_ms + state.opts.idle_threshold_ms)
  if cutoff_ms > active.last_tick_ms then
    add_time(active.bufnr, cutoff_ms - active.last_tick_ms)
  end

  active.last_tick_ms = now
end

local function set_active_buffer(bufnr, now)
  if state.active.bufnr == bufnr then
    state.active.last_activity_ms = now
    return
  end

  flush_active(now)
  state.active.bufnr = bufnr
  state.active.last_tick_ms = now
  state.active.last_activity_ms = now
end

local function record_activity()
  set_active_buffer(current_buffer(), now_ms())
end

local function refresh_winbar()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    return
  end

  lualine.refresh { place = { 'winbar' } }
end

local function timer_tick()
  flush_active(now_ms())
  refresh_winbar()
end

local function format_seconds(total_seconds)
  local rounded = math.floor(total_seconds + 0.5)
  local minutes = math.floor(rounded / 60)
  local seconds = rounded % 60

  if rounded < 3600 then
    return ('%d:%02d'):format(minutes, seconds)
  end

  local hours = math.floor(minutes / 60)
  minutes = minutes % 60
  return ('%d:%02d:%02d'):format(hours, minutes, seconds)
end

function M.get_seconds(bufnr)
  if not is_trackable_buffer(bufnr) then
    return nil
  end

  local total = state.totals[bufnr] or 0
  local active = state.active
  if active.bufnr ~= bufnr or not active.last_tick_ms then
    return total
  end

  local now = now_ms()
  local cutoff_ms = math.min(now, active.last_activity_ms + state.opts.idle_threshold_ms)
  if cutoff_ms <= active.last_tick_ms then
    return total
  end

  return total + ((cutoff_ms - active.last_tick_ms) / 1000)
end

function M.get_display(bufnr)
  local seconds = M.get_seconds(bufnr)
  if not seconds then
    return ''
  end

  return (' %s'):format(format_seconds(seconds))
end

function M.stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end

  flush_active(now_ms())
end

function M.setup(opts)
  if state.timer then
    return M
  end

  state.opts = vim.tbl_deep_extend('force', vim.deepcopy(defaults), opts or {})

  local group = vim.api.nvim_create_augroup('kickstart-file-time', { clear = true })
  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufWinEnter',
    'CursorMoved',
    'CursorMovedI',
    'InsertEnter',
    'InsertLeave',
    'TextChanged',
    'TextChangedI',
    'WinEnter',
    'FocusGained',
  }, {
    group = group,
    callback = record_activity,
  })

  vim.api.nvim_create_autocmd('FocusLost', {
    group = group,
    callback = function()
      flush_active(now_ms())
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args)
      flush_active(now_ms())
      state.totals[args.buf] = nil
      if state.active.bufnr == args.buf then
        state.active.bufnr = nil
        state.active.last_tick_ms = nil
        state.active.last_activity_ms = nil
      end
      refresh_winbar()
    end,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      M.stop()
    end,
  })

  record_activity()

  state.timer = uv.new_timer()
  state.timer:start(0, state.opts.tick_ms, vim.schedule_wrap(timer_tick))

  return M
end

return M
