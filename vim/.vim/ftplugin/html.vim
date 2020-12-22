set colorcolumn=-1
set linebreak

let g:boilerplate = $HOME."/.vim/boilerplates/html.html"

inoremap ;; ;
inoremap <expr> ;! "<esc>:r ".boilerplate."\n"

let g:tags = split("p i b div h1 h2 h3 h4 h5 h6 span ul ol li")

for tag in g:tags
	execute substitute("inoremap ;_ <_></_><space>++<esc>2F>a", "_", tag, "g")
endfor

inoremap ;a <a></a<space>href="++"><space>++<esc>2F>a
inoremap ;img <img<space>src=""<space>alt="++"><space>++<esc>3F"i

function! ImageInsert(query)
	eval system("img " . a:query)
	r!xclip -selection primary -o
	execute "normal 0i<img alt=\"" . a:query . "\" src=\"\<esc>A\">"
endfunction

:command! -nargs=1 Im :call ImageInsert(<q-args>)
