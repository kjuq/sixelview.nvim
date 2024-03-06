local M = {}

local group = vim.api.nvim_create_augroup("kjuq_sixelview_group", {})
local offset = 100

local echoraw = function(str)
	vim.fn.chansend(vim.v.stderr, str)
end

local send_sequence = function(path, lnum, cnum)
	-- https://zenn.dev/vim_jp/articles/358848a5144b63#%E7%94%BB%E5%83%8F%E8%A1%A8%E7%A4%BA%E9%96%A2%E6%95%B0%E3%81%AE%E4%BE%8B
	-- save cursor pos
	echoraw("\27[s")
	-- move cursor pos
	echoraw(string.format("\27[%d;%dH", lnum, cnum))
	-- display sixels
	echoraw(vim.fn.system(string.format("img2sixel %s", path)))
	-- restore cursor pos
	echoraw("\27[u")
end

local display_sixel = function(img_path)
	local win_position = vim.api.nvim_win_get_position(0)
	local y = win_position[1]
	local x = win_position[2]
	send_sequence(img_path, y, x + 1)
end

local callback = function()
	local img_path = vim.fn.expand("%:p")

	local defered_proc = function()
		local cur_path = vim.fn.expand("%:p")
		if img_path == cur_path then
			display_sixel(img_path)
		end
	end

	vim.defer_fn(defered_proc, offset)
end

M.setup = function()
	-- TODO: check if the environment is supporting SIXEL

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		pattern = "*.png",
		group = group,
		callback = callback,
	})
end

return M
