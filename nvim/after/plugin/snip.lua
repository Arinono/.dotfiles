local keymap = require('arinono.keymap')
local ls = require('luasnip')
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

nnoremap("<C-k>", expand_or_jump_fwd)
snoremap("<C-k>", expand_or_jump_fwd)
nnoremap("<C-j>", expand_or_jump_bwd)
snoremap("<C-j>", expand_or_jump_bwd)
inoremap("<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

nnoremap("<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/snip.lua<cr>")
