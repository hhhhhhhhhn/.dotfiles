if exists("g:in_notes")
	finish
endif
let g:in_notes = 1

set autochdir

nnoremap <leader>l :!$TERMINAL -embed $(xdotool getwindowfocus) -e sh -c "cd '%:p:h' && search ~/Notes > /tmp/search"<CR><CR>:r! tomdlink </tmp/search<CR>
nnoremap <leader>o :!$TERMINAL -embed $(xdotool getwindowfocus) -e sh -c "cd '%:p:h' && search ~/Notes > /tmp/search"<CR><CR>:let @x = readfile("/tmp/search")[0]<CR>:e <C-r>x<CR>

function! Follow()
	let line = getline(".")
	" Links with angle brackets
	let matched = matchlist(line, '\](<\([^\]]*\)>)')

	" Links without brackets
	if len(matched) == 0
		let matched = matchlist(line, '\](\([^\]]*\))')
	endif

	" Give up, try to open with gx
	if len(matched) == 0
		call feedkeys("gx")
		return
	endif

	execute "edit " . matched[1]
endfunction

nnoremap <CR> :call Follow()<CR>
