M = {}

---@type sixelview.Options
M.default = {
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
	-- whether showing an image automatically when an image buffer is opened
	auto = true,
	-- time of delay before showing image
	-- try setting this duration longer if you have a trouble showing image
	delay_ms = 100,
}

return M
