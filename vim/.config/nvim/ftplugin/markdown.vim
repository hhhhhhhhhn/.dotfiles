function! ImageInsert(query)
	eval system("img " . a:query)
	r!xclip -selection clipboard -o
	execute "normal 0i![" . a:query . "](\<Esc>A)"
endfunction

:command! -nargs=1 Im :call ImageInsert(<q-args>)

inoremap <C-H> <esc>0xx<esc>A
inoremap <C-L> <esc>I  <esc>A
