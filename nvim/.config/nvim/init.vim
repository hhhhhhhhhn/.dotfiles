colorscheme peachpuff
set tabstop=4 shiftwidth=4 colorcolumn=81

fun! CharAtCursor()
	return strcharpart(strpart(getline("."), col(".") - 1), 0, 1)
endfun

inoremap ( ()<left>
inoremap { {}<left>
inoremap [ []<left>

inoremap <expr> " (CharAtCursor() == '"' ? "<right>" : '""<left>')
inoremap <expr> ) (CharAtCursor() == ")" ? "<right>" : ")")
inoremap <expr> } (CharAtCursor() == "}" ? "<right>" : "}")
inoremap <expr> ] (CharAtCursor() == "]" ? "<right>" : "]")

autocmd FileType markdown setlocal wrap linebreak nolist
