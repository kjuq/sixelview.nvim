local M = {}

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
			vim.defer_fn(function()
				display_sixel(img_path)
			end, offset)
		end
	end

	vim.defer_fn(defered_proc, offset)
end

local sixelview_cmd = function(pattern)
	local img_path = vim.fn.expand("%:p")

	-- check if the current buffer's extension is image
	local curbuf_is_img = false
	for _, pat in pairs(pattern) do
		local img_extension = string.sub(img_path, #img_path - (#pat - 2))
		local pat_extension = string.sub(pat, 2)
		if img_extension == pat_extension then
			curbuf_is_img = true
			break
		end
	end

	if not curbuf_is_img then
		vim.api.nvim_err_writeln("The current buffer is not an image.")
		return
	end

	vim.defer_fn(function()
		display_sixel(img_path)
	end, offset)
end

local default_opts = {
	-- list of supported source format by `img2sixel`
	-- https://manpages.ubuntu.com/manpages/xenial/man1/img2sixel.1.html#image%20loaders
	pattern = {
		-- JPEG
		"*.jpeg",
		"*.jpg",
		"*.jpe",
		"*.jfif",
		"*.jfi",
		"*.jif",

		-- PNG
		"*.png",

		-- TGA
		"*.tga",
		"*.icb",
		"*.vda",
		"*.vst",

		-- BMP
		"*.bmp",
		"*.dib",

		-- PSD
		"*.psd",

		-- GIF
		"*.gif",

		-- PIC
		"*.pic",

		-- PNM
		"*.ppm",
		"*.pgm",
		"*.pbm",
		"*.pnm",
	},
	auto = true,
}

M.setup = function(opts)
	opts = vim.tbl_deep_extend("force", default_opts, opts)

	-- TODO: check if the environment is supporting SIXEL

	if opts.auto then
		vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
			pattern = opts.pattern,
			group = vim.api.nvim_create_augroup("sixelview_kjuq", {}),
			callback = callback,
		})
	end

	vim.api.nvim_create_user_command("SixelView", function()
		sixelview_cmd(opts.pattern)
	end, {})
end

return M
