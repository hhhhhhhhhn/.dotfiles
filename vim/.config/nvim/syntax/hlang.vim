syntax match escapeSeq contained /\\./

syntax keyword Keyword fn if elseif else while for loop break continue return let extern global space
syntax region String start=/"/ end=/"/ contains=escapeSeq
syntax region Comment start=/#/ end=/\n/
syntax match Number /\s-\?0[xbo][0-9a-f_]\+\|\s-\?[0-9_]\+/hs=s+1
syntax match String /'.'/

highlight def link escapeSeq SpecialChar
