local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("htmldjango", {
  s(
    "_ablk",
    fmt(
      [[
        {{% block {} %}}
          {}
        {{% endblock %}}
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    "_afor",
    fmt(
      [[
        {{% for {} in {} %}}
          {}
        {{% endfor %}}
      ]],
      { i(1), i(2), i(3) }
    )
  ),
  s(
    "_amatch",
    fmt(
      [[
        {{% match {} %}}
          {}
        {{% endmatch %}}
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    "_awhen",
    fmt(
      [[
        {{% when {} with ({}) %}}
          {}
      ]],
      { i(1), i(2), i(3) }
    )
  ),
})
