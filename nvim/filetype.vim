if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.hbs,*.handlebars setf handlebars
augroup END
