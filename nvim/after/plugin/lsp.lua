local map = require("arinono.keymap")
local nnoremap = map.nnoremap

require("neoconf").setup({
	import = {
		vscode = false,
	},
})

local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.setup_servers({
	"tsserver",
	"eslint",
	"rust-analyzer",
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

local cmp = require("cmp")
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mapping = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-e>"] = cmp.mapping.close(),
})

cmp_mapping["<CR>"] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mapping,
})

local config = require("lspconfig")

config.lua_ls.setup({
	settings = {
		Lua = {
			telemetry = { enable = false },
		},
	},
})

config.htmx.setup({})

local util = require("lspconfig.util")
local function get_typescript_server_path(root_dir)
	local global_ts = "/Users/arinono/Library/pnpm/global/5/node_modules/typescript/lib"
	-- Alternative location if installed as root:
	-- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
	local found_ts = ""
	local function check_dir(path)
		found_ts = util.path.join(path, "node_modules", "typescript", "lib")
		if util.path.exists(found_ts) then
			return path
		end
	end
	if util.search_ancestors(root_dir, check_dir) then
		return found_ts
	else
		return global_ts
	end
end

config.volar.setup({
	filetypes = { "vue" },
	on_new_config = function(new_config, new_root_dir)
		new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
	end,
})

lsp.on_attach(function(client, buff)
	local opts = { buffer = buff, remap = false }

	nnoremap("<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	nnoremap("<leader>vca", vim.lsp.buf.code_action, opts)
	nnoremap("<leader>qf", function()
		vim.lsp.buf.code_action({
			apply = true,
		})
	end, opts)
	nnoremap("<leader>rn", vim.lsp.buf.rename, opts)
	nnoremap("<C-h>", vim.lsp.buf.signature_help, opts)
	nnoremap("K", vim.lsp.buf.hover, opts)
	nnoremap("gd", vim.lsp.buf.definition, opts)
	nnoremap("gD", vim.lsp.buf.declaration, opts)
	nnoremap("gi", vim.lsp.buf.implementation, opts)
	nnoremap("gr", vim.lsp.buf.references, opts)
	nnoremap("go", vim.lsp.buf.type_definition, opts)

	-- disable ts LS client when in deno
	if util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
		if client.name == "tsserver" then
			client.stop()
		end
	else
		if client.name == "denols" then
			client.stop()
		end
	end
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
	},
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = {
		reverse = true,
	},
	float = {
		source = "always",
	},
})

nnoremap("<leader>do", function()
	vim.diagnostic.open_float(vim.api.nvim_get_current_buf(), { scope = "line" })
end)

lsp.format_mapping("<leader><leader>f", {
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua", "vue", "html" },
	},
})

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "lua" },
	},
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- Replace these with the tools you have installed
		null_ls.builtins.formatting.prettier.with({
			extra_args = {
				"--single-quote",
				"--jsx-single-quote",
				"--trailing-comma all",
				"--single-attribute-per-line",
				"--prose-wrap always",
			},
		}),
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.diagnostics.eslint,
	},
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
})
