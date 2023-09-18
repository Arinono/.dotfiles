local keymap = require("arinono.keymap")
local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local isn = ls.indent_snippet_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local nnoremap = keymap.nnoremap
local snoremap = keymap.snoremap
local inoremap = keymap.inoremap

function expand_or_jump_fwd()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end

function expand_or_jump_bwd()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end

nnoremap("<C-k>", expand_or_jump_fwd, { silent = true })
snoremap("<C-k>", expand_or_jump_fwd, { silent = true })
nnoremap("<C-j>", expand_or_jump_bwd, { silent = true })
snoremap("<C-j>", expand_or_jump_bwd, { silent = true })
inoremap("<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

nnoremap("<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/snip.lua<cr>")

if vim.g.snippets == "luasnip" then
	return
end

ls.config.set_config({
	history = true,

	updateevents = "TextChanged,TextChangedI",
	enable_autosnippet = false,
})

ls.cleanup()

ls.add_snippets("all", {
	ls.parser.parse_snippet({ trig = "te", wordTrig = false }, "${1:cond} ? ${2:lhs} : ${3:rhs}"),
})

ls.add_snippets("tape", {
	s("init", {
		isn(
			1,
			t({
				"",
			})
		),
	}),
})

local keys = isn(1, t({ "const keys = Object.keys as <T>(obj: T) => Array<keyof T>" }), "$PARENT_INDENT")
local values = isn(1, t({ "const values = Object.values as <T>(obj: T) => Array<T[keyof T]>" }), "$PARENT_INDENT")
local entries = isn(
	1,
	t({
		"const entries = Object.entries as <T>(",
		"  o: T",
		") => Array<[keyof T, T[keyof T]]>",
	}),
	"$PARENT_INDENT"
)

ls.add_snippets("ts", {
	s("entries", entries),
	s("keys", keys),
	s("values", values),
})

ls.add_snippets("vue", {
	s("entries", entries),
	s("keys", keys),
	s("values", values),
	s("_uuid", t("const { uuid } = useUUID();")),
	s("_ret_uuid", t({ "return {", "  uuid,", "};" })),
	s("_title", {
		isn(
			1,
			t({
				"const { uuid } = useUUID();",
				"const { title } = useTitle({ uuid });",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_i18n", {
		isn(
			1,
			t({
				"const { t } = useI18n({",
				"  messages:",
				"});",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_stp", {
		isn(
			1,
			t({
				"setup() {",
				"  const { uuid } = useUUID();",
				"",
				"  return {",
				"    uuid,",
				"  };",
				"},",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_unsaved", {
		isn(
			1,
			t({
				"const {",
				"  hasUnsavedChanges,",
				"  beforeRouteLeaveGuard,",
				"} = useHasUnsavedChanges();",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_wa_title", {
		isn(
			1,
			t({
				"watch(_title, (val, oldVal) => {",
				"  if (val !== oldVal) {",
				"    title.value = val;",
				"  }",
				"});",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_sdk", t("const { sdk } = useSDK();")),
	s("_bus", t("const { emit: busEmit } = useBusHandler();")),
	s("_emits", {
		isn(
			1,
			t({
				"const emit = defineEmits<{",
				"  'update:model-value': [unknown],",
				"}>();",
			}),
			"$PARENT_INDENT"
		),
	}),
	s("_hasRight", t("const hasRight: undefined | ((value: string) => boolean) = inject('hasRight');")),
	s(
		"_pushRoute",
		t("const pushRoute: ((location: RouteLocationRaw) => Promise<boolean>) | undefined = inject('pushRoute');")
	),
})
