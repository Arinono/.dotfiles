local nnoremap = require("arinono.keymap").nnoremap

vim.cmd([[
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  inoremap <silent><expr> <c-space> coc#pum#confirm()
]])

function show_documentation()
  local filetype = vim.bo.filetype
  if filetype == "vim" or filetype == "help" then
    vim.api.nvim_command("h " .. vim.fn.expand("<cword>"))
  elseif vim.fn["coc#rpc#ready"]() then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command(
      "!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>")
    )
  end
end

nnoremap('K', ':lua show_documentation()<cr>')
