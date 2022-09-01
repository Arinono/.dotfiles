vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'sbdchd/neoformat'

  -- Theme
  use 'marko-cerovac/material.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Lang
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'dart-lang/dart-vim-plugin'
  use 'github/copilot.vim'

  -- Lang: Svelte
  use { 'evanleck/vim-svelte',
    branch = 'main',
    requires = { 'othree/html5.vim', 'pangloss/vim-javascript' }
  } 

  -- Misc
  use 'andweeb/presence.nvim'

  -- Longue vue
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'nvim-treesitter/nvim-treesitter-context'
end)
