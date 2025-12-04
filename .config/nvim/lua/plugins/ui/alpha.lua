return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'Colamint/pokemon.nvim',
  },
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    local pokemon = require 'pokemon'

    local function footer()
      local ascii = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

    -- local ascii = {
    --   [[                                                                       ]],
    --   [[                                                                       ]],
    --   [[                                                                       ]],
    --   [[                                                                       ]],
    --   [[                                                                     ]],
    --   [[       ████ ██████           █████      ██                     ]],
    --   [[      ███████████             █████                             ]],
    --   [[      █████████ ███████████████████ ███   ███████████   ]],
    --   [[     █████████  ███    █████████████ █████ ██████████████   ]],
    --   [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    --   [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    --   [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    --   [[                                                                       ]],
    --   [[                                                                       ]],
    --   [[                                                                       ]],
    -- }

      local plugins_count = vim.fn.len(vim.fn.globpath('~/.local/share/nvim/site/pack/packer/start', '*', 0, 1))
      local datetime = os.date '  %m-%d-%Y   %H:%M:%S'
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
      return datetime .. '   Plugins ' .. plugins_count .. nvim_version_info .. '\n' .. ascii 
    end

    pokemon.setup {
      number = 'random',
      size = 'auto',
    }
    dashboard.section.header.val = pokemon.header()
    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', [[<leader>sf]]),
      dashboard.button('n', ' ' .. ' New file', [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button('r', ' ' .. ' Recent files', [[<leader>s.]]),
      dashboard.button('g', ' ' .. ' Find text', [[<leader>sg]]),
      dashboard.button('c', ' ' .. ' Config', [[<cmd> e ~/.config/nvim/ <cr>]]),
      dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd> Lazy <cr>'),
      dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
    }
    dashboard.section.footer.val = footer()
    alpha.setup(dashboard.config)
  end,

  vim.api.nvim_set_keymap('n', '<F2>', '<cmd>PokemonTogglePokedex<cr>', {
    noremap = true,
    desc = 'PokemonTogglePokedex',
  }),
  }
