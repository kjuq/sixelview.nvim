local M = {}

local utils = require("sixelview.utils")
local config = require("sixelview.config")

---@param pattern string[]
---@param delay_ms number
local sixelview_cmd = function(pattern, delay_ms)
	local img_path = vim.fn.expand("%:p")
	if not utils.is_image_buffer(img_path, pattern) then
		vim.notify("The current buffer is not an image.", vim.log.levels.ERROR)
		return
	end
	utils.defer_display_sixel(delay_ms)
end

---@param opts sixelview.Options
M.setup = function(opts)
	opts = vim.tbl_deep_extend("force", config.default, opts)

	if opts.auto then
		vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
			pattern = opts.pattern,
			group = vim.api.nvim_create_augroup("sixelview_kjuq", {}),
			callback = function()
				utils.defer_display_sixel(opts.delay_ms)
			end,
		})
	end

	vim.api.nvim_create_user_command("SixelView", function()
		sixelview_cmd(opts.pattern, opts.delay_ms)
	end, {})
end

return M
