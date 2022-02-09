set colorcolumn=-1
set linebreak

function! ImageInsert(query)
	eval system("img " . a:query)
	r!xclip -selection clipboard -o
	execute "normal 0i![" . a:query . "](\<Esc>A)"
endfunction

:command! -nargs=1 Im :call ImageInsert(<q-args>)

nnoremap <leader>l :!$TERMINAL -embed $(xdotool getwindowfocus) -e sh -c "cd '%:p:h' && search ~/notes > /tmp/search"<CR><CR>:r! tomdlink </tmp/search<CR>

inoremap <C-H> <esc><<A
inoremap <C-L> <esc>>>A
