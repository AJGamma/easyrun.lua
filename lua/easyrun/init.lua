local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values

M.setup = function() end

local pick_commands = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "easyrun options",
			finder = finders.new_table({
				results = {
					{ option = "Build", command = "cd $projectroot; make all" },
					{ option = "Run", command = "cd $projectroot; ./result" },
					{ option = "Test", command = "cd $projectroot; make test" },
				},
				entry_maker = function(entry)
					return {
						display = entry.option,
						ordinal = entry.option,
						content = entry.command,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.new_buffer_previewer({
				title = "Run Commands",
				define_preview = function(self, entry)
					vim.api.nvim_buf_set_lines(
						self.state.bufnr,
						0,
						0,
						true,
						vim.iter({
							entry.content,
							vim.split(vim.inspect(entry), "\n"),
						}):flatten():totable()
					)
				end,
			}),
		})
		:find()
end

-- to execute the function
-- pick_commands()

pick_commands(require("telescope.themes").get_dropdown{})

M.RunCurrentFile = function() end

M.RunWithOption = function()
	-- use telescope to show options, after picking options, run the file
end

M.SetCurrentFileArgs = function()
	-- set argument for current file
end

return M
