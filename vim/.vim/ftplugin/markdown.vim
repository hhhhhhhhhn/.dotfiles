set colorcolumn=-1
set linebreak

function! ImageInsert(query)
	eval system("img " . a:query)
	r!xclip -selection clipboard -o
	execute "normal 0i![" . a:query . "](\<Esc>A)"
endfunction

:command! -nargs=1 Im :call ImageInsert(<q-args>)
