local M = {}

---@param str string
local echoraw = function(str)
	vim.fn.chansend(vim.v.stderr, str)
end

---@param path string
---@param lnum number
---@param cnum number
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

---@param img_path string
local display_sixel = function(img_path)
	local win_position = vim.api.nvim_win_get_position(0)
	local y = win_position[1]
	local x = win_position[2]
	send_sequence(img_path, y, x + 1)
end

---@param delay_ms number
M.defer_display_sixel = function(delay_ms)
	local img_path = vim.fn.expand("%:p")

	local defered_proc = function()
		local cur_path = vim.fn.expand("%:p")
		if img_path == cur_path then
			vim.defer_fn(function()
				display_sixel(img_path)
			end, delay_ms)
		end
	end

	vim.defer_fn(defered_proc, delay_ms)
end

---@param img_path string
---@param pattern string[]
---@return boolean
M.is_image_buffer = function(img_path, pattern)
	for _, pat in pairs(pattern) do
		local img_extension = string.lower(string.sub(img_path, #img_path - (#pat - 2)))
		local pat_extension = string.lower(string.sub(pat, 2))
		if img_extension == pat_extension then
			return true
		end
	end
	return false
end

return M
