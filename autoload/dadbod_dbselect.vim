scriptencoding utf-8

function! s:get_configs()
	let l:configs = {}
	for F in g:database_config_loaders
		let l:c = F()
		if type(l:c) ==# v:t_dict
			call extend(l:configs, l:c)
		endif
	endfor
	call extend(l:configs, g:database_configs)

	return l:configs
endfunction

function! dadbod_dbselect#get_by_selection(selection)
	let l:configs = s:get_configs()
	if has_key(l:configs, a:selection)
		if type(l:configs[a:selection]) == v:t_func
			return l:configs[a:selection]()
		else
			return l:configs[a:selection]
		endif
	endif
	return ""
endfunction

function! dadbod_dbselect#db_selected(selection)
	let l:config = dadbod_dbselect#get_by_selection(a:selection)
	if empty(l:config)
		return
	endif
	let b:db = l:config
endfunction

function! dadbod_dbselect#get_choices()
	let l:configs = s:get_configs()
	let l:keys = sort(keys(l:configs))
	return l:keys
endfunction

function! dadbod_dbselect#db_select_vim_ui_select()
lua << EOF
	local results = vim.fn['dadbod_dbselect#get_choices']()
	vim.ui.select(results, {prompt = 'Select a database: '}, function(selection)
		vim.fn['dadbod_dbselect#db_selected'](selection)
	end)
EOF
endfunction

function! dadbod_dbselect#db_select_fzf()
	call fzf#run(fzf#wrap({ 'source': dadbod_dbselect#get_choices(), 'sink': { selection -> dadbod_dbselect#db_selected(selection) } }))
endfunction
