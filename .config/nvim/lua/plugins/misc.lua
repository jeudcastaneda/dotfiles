-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'chrishrb/gx.nvim',
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    submodules = false,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
      routes = {
        filter = { event = 'notify', find = 'No information available' },
        opts = { skip = true },
      },
      preset = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to arr proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      -- `nvim-notify` is only needed, if yo want to use the notification view.
      -- if not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup {
        enable_builtin = true,
        use_local_fs = true,
      }
      vim.cmd [[hi OctoEditable guibg=none]]
      vim.treesitter.language.register('markdown', 'octo')
    end,
    keys = {
      { '<leader>O', '<cmd>Octo<cr>', desc = 'Octo' },
      { '<leader>Op', '<cmd>Octo pr list<cr>', desc = 'Octo pr list' },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        svelte = { 'eslint_d' },
        kotlin = { 'ktlint' },
        terraform = { 'tflint' },
        ruby = { 'standardrb' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          svelte = { { 'prettierd', 'prettier', stop_after_first = true } },
          astro = { { 'prettierd', 'prettier', stop_after_first = true } },
          javascript = { { 'prettierd', 'prettier', stop_after_first = true } },
          typescript = { { 'prettierd', 'prettier', stop_after_first = true } },
          javascriptreact = { { 'prettierd', 'prettier', stop_after_first = true } },
          typescriptreact = { { 'prettierd', 'prettier', stop_after_first = true } },
          json = { { 'prettierd', 'prettier', stop_after_first = true } },
          graphql = { { 'prettierd', 'prettier', stop_after_first = true } },
          java = { 'google-java-format' },
          kotlin = { 'ktlint' },
          ruby = { 'standardrb' },
          markdown = { { 'prettierd', 'prettier', stop_after_first = true } },
          erb = { 'htmlbeautifier' },
          html = { 'htmlbeautifier' },
          bash = { 'beautysh' },
          proto = { 'buf' },
          rust = { 'rustfmt' },
          yaml = { 'yamlfix' },
          toml = { 'taplo' },
          css = { { 'prettierd', 'prettier', stop_after_first = true } },
          scss = { { 'prettierd', 'prettier', stop_after_first = true } },
          sh = { 'shellcheck' },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>l', function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end, { desc = 'Format file or range (in visual mode)' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        max_lines = 5,
      }
    end,
    {
      'windwp/nvim-ts-autotag',
      dependencies = 'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-ts-autotag').setup {}
      end,
      lazy = true,
      event = 'VeryLazy',
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      require 'illuminate'
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      jump = {
        autojump = true,
      },
      modes = {
        char = {
          jump_labels = true,
          multi_line = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n" },           function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    },
  },
  {
  'mg979/vim-visual-multi', branch = 'master'
  },
}
