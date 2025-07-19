-- Add current directory to runtimepath
vim.opt.runtimepath:prepend "."

-- Add all dependencies from .deps directory
local deps_path = ".deps"
if vim.fn.isdirectory(deps_path) == 1 then
  for name, type in vim.fs.dir(deps_path) do
    if type == "directory" then
      local dep_path = deps_path .. "/" .. name
      vim.opt.runtimepath:append(dep_path)
    end
  end
end

-- Set up test environment
_G.__is_log = true
vim.fn.setenv("DEBUG_PLENARY", true)

-- Load plugins
vim.cmd "runtime! plugin/plenary.vim"
vim.cmd "runtime! plugin/octo.nvim"

-- Load test utilities
require "plenary.busted"
require "tests.test_utils"

-- Setup octo with minimal config
require("octo").setup()
