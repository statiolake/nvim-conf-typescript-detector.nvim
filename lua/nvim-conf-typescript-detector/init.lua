local nc = require 'nvim-conf'

local M = {}

local default_opts = {
  forceTsserver = false,
  forceDeno = false,
}

function M.should_enable_tsserver()
  local opts = nc.get().typescript_detector or default_opts
  return opts.forceTsserver or M.opened_node_project()
end

function M.should_enable_deno()
  local opts = nc.get().typescript_detector or default_opts
  return opts.forceDeno or not M.opened_node_project()
end

function M.opened_node_project()
  local util = require 'lspconfig.util'
  local node_root_dir = util.root_pattern('node_modules', 'package.json')

  local fname = vim.api.nvim_buf_get_name(0)
  if not fname or fname == '' then
    fname = vim.fn.getcwd() or ''
  end
  fname = util.path.sanitize(fname)

  return node_root_dir(fname) ~= nil
end

return M
