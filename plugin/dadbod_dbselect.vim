if exists('g:loaded_dadbod_dbselect') || &compatible || v:version < 700
  finish
endif

let g:loaded_dadbod_dbselect = 1
if !exists('g:dadbods')
	let g:dadbods = {}
endif

if !exists("g:dadbods_loaders")
	let g:dadbods_loaders = []
endif
