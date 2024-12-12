require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup {
  require 'plugins.ai.copilot-chat',
  require 'plugins.ai.copilot',
  require 'plugins.bufferline',
  require 'plugins.comment',
  require 'plugins.dap.core',
  require 'plugins.dap.nlua',
  require 'plugins.gitsigns',
  require 'plugins.harpoon',
  require 'plugins.indent-blankline',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.misc',
  require 'plugins.neoclip',
  require 'plugins.neotree',
  require 'plugins.nvim-ufo',
  require 'plugins.obsidian',
  require 'plugins.oil',
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.ui.alpha',
  require 'plugins.ui.colortheme',
  require 'plugins.ui.dashboard-nvim',
  require 'plugins.ui.edgy',
  require 'plugins.ui.treesitter-context',
}
