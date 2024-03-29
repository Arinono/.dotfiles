vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Theme
	use("marko-cerovac/material.nvim")
	use("folke/tokyonight.nvim")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = false },
	})

	-- LSP
	use("folke/neoconf.nvim")
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },

			-- Bonus
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jay-babu/mason-null-ls.nvim" },
		},
	})
	-- use({
	-- 	"pmizio/typescript-tools.nvim",
	-- 	requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- })

	-- Edition
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-context",
		requires = { "nvim-treesitter/nvim-treesitter" },
	})
	use("mbbill/undotree")
	use({
		"brenoprata10/nvim-highlight-colors",
		consfig = function()
			require("nvim-highlight-colors").setup({
				enable_tailwind = true,
			})
		end,
	})
	use({
		"ThePrimeagen/harpoon",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("laytan/cloak.nvim")

	use({
		"nvim-treesitter/playground",
		requires = { "nvim-treesitter/nvim-treesitter" },
	})

	use({ "folke/which-key.nvim" })
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	-- Lang
	use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use("ellisonleao/glow.nvim")
	use("NoahTheDuke/vim-just")

	-- Telescope
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	})
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Misc
	use("andweeb/presence.nvim")
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = { "tpope/vim-dadbod" },
	})
	use({ "f-person/git-blame.nvim" })

	use({
		"kadobot/nvim-spotify",
		requires = "nvim-telescope/telescope.nvim",
		run = "make",
	})

	-- Late load
	use({ "github/copilot.vim" })
	use({ "smithbm2316/centerpad.nvim" })
	use({ "michaelrommel/nvim-silicon" })
end)
