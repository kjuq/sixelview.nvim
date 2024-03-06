local M = {}

local offset = 100
local group = vim.api.nvim_create_augroup("kjuq_img_viewer_user_group", {})

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

M.setup = function()
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		pattern = "*.png",
		group = group,
		callback = function()
			local img_path = vim.fn.expand("%:p")

			local timer = vim.uv.new_timer()
			if timer == nil then
				return
			end

			local defered_proc = function()
				timer:stop()
				display_sixel(img_path)
			end

			timer:start(offset, 0, vim.schedule_wrap(defered_proc))
		end,
	})
end

return M
