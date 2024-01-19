if exists('g:loaded_dadbod_dbselect') || &compatible || v:version < 700
  finish
endif

let g:loaded_dadbod_dbselect = 1
if !exists('g:database_configs')
	let g:database_configs = {}
endif

if !exists("g:database_config_loaders")
	let g:database_config_loaders = []
endif
