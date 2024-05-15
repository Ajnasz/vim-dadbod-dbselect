local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

function find(telescope_opts)

	local results = vim.fn['dadbod_dbselect#get_choices']()
	pickers.new(telescope_opts, {
		prompt_tile = "dadbod_dbselect",

		sorter = conf.generic_sorter(telescope_opts),

		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				vim.fn['dadbod_dbselect#db_selected'](selection.value)
			end)
			return true
		end,

		finder = finders.new_table({
			results = results,
			entry_maker = telescope_opts.entry_maker
		}),
	}):find()
end

return telescope.register_extension {
  setup = function(opts) return opts end,
  exports = { ["vim-dadbod-dbselect"] = find }
}
