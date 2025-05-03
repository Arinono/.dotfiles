local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

local keys = s("_keys", fmt("const keys = Object.keys as <T>(obj: T) => Array<keyof T>;", {}))
local values =
  s("_values", fmt("const values = Object.values as <T>(obj: T) => Array<T[keyof T]>;", {}))
local entries = s(
  "_entries",
  fmt("const entries = Object.entries as <T>(obj: T) => Array<[keyof T, T[keyof T]]>;", {})
)

ls.add_snippets("typescript", {
  keys,
  values,
  entries,
})

ls.add_snippets("vue", {
  keys,
  values,
  entries,
})
