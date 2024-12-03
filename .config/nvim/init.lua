require 'core.options'  -- Load general options
require 'core.keymaps'  -- Load general keymaps
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
  require 'plugins',
  require 'plugins.debbugging',
  require 'plugins.oil',
  require 'plugins.obsidian',
  require 'plugins.harpoon',
  require 'plugins.neoclip',
  require 'plugins.neotree',
  require 'plugins.nvim-ufo',
  require 'plugins.colortheme',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.gitsigns',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.comment',
}

-- vim.cmd("colorscheme tokyonight-storm")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
