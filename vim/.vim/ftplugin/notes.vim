if exists("g:in_notes")
	finish
endif
let g:in_notes = 1

set autochdir

nnoremap <leader>l :tabnew<CR>:terminal search ~/Notes > /tmp/search<CR>:autocmd BufLeave <buffer> call feedkeys(":r! tomdlink </tmp/search\n")<CR>i
nnoremap <leader>o :tabnew<CR>:terminal search ~/Notes > /tmp/search<CR>:autocmd BufLeave <buffer> call feedkeys(":execute 'edit ' . readfile('/tmp/search')[0]\n")<CR>i

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
vnoremap <CR> c[<C-r>"](<<C-r>".md>)<ESC>
