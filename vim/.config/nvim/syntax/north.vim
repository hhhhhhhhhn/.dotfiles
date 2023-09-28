syntax match escapeSeq contained /\\./

syntax keyword Keyword fn end if else loop break extern global return local struct space
syntax region String start=/"/ end=/"/ contains=escapeSeq
syntax region Comment start=/#/ end=/\n/
syntax match Number /\s-\?0[xb][0-9a-f_]\+\|\s-\?[0-9_]\+/hs=s+1

highlight def link escapeSeq SpecialChar
